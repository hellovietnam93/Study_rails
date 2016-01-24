class ImportService
  attr_accessor :file_path, :model, :attributes, :verify_attributes, :type
  def initialize file_path, model, verify_attributes, data_type, class_room = nil, course = nil
    @file_path = file_path
    @model = model
    @verify_attributes = verify_attributes
    @data_type = data_type
    @hash_verify_attributes = {}
    @class_room = class_room
    @course = course
  end

  def valid?
    File.exists?(@file_path) && (is_csv? || is_json?)
  end

  def save!
    if is_csv?
      save_from_csv
    elsif is_json?
      save_from_json
    end
  end

  private
  def find_columns
    Settings.imports.to_hash.detect{|key, _| key.to_s == @model.to_s.downcase}[1]
  end

  def is_csv?
    Settings.imports.file_types.csv.include?(File.extname(@file_path)) &&
      csv_data_type_valid?
  end

  def is_json?
    Settings.imports.file_types.json == File.extname(@file_path)
  end

  def csv_data_type_valid?
    csv_headers = Set.new CSV.open(@file_path, "r"){|csv| csv.first}
    model_attributes = Set.new model.send(:new).attributes.keys
    if model.send :const_defined?, :CSV_REJECT_ATTRIBUTES
      model_attributes -= Set.new model::CSV_REJECT_ATTRIBUTES
    end

    if @model.name == "Question"
      model_attributes.subset? csv_headers
    else
      csv_headers.subset? model_attributes
    end
  end

  def save_from_csv
    header = CSV.open(@file_path, "r") {|csv| csv.first}

    if check_right_model header, @data_type
      CSV.foreach @file_path, {headers: :first_row} do |row|
        if @model.name == "Question"
          import_question row
        else
          save_object get_object_attributes(row)
        end
      end
      return true
    end
    return false
  end

  def save_from_json
    datas = JSON.parse(File.read(@file_path).gsub("\\", "").gsub "\n", "")
    header = datas.first

    if check_right_model header, @data_type
      datas.each {|data| save_object get_object_attributes(data)}
      return true
    end
    return false
  end

  def save_object model_attributes
    model_attributes.delete :id
    convert_to_hash model_attributes

    if @object = @model.send(:find_by, @hash_verify_attributes)
      @object.send :update_attributes, model_attributes
    else
      @model.send :create, model_attributes
    end
  end

  def get_object_attributes data
    data = @model.send(:standardize_data_to_import, data) if @model.respond_to? :standardize_data_to_import
    model_attributes = {}
    find_columns.each {|key, val| model_attributes[key.to_sym] = data[val]}
    if @model.respond_to? :standardize_csv_data
      @model.send :standardize_csv_data, model_attributes
    else
      model_attributes
    end
  end

  def check_right_model header, data_type
    case data_type
    when Settings.data_types_import.prime_user
      header.include? Settings.collum_check_import.prime_user
    when Settings.data_types_import.prime_class
      header.include? Settings.collum_check_import.prime_class
    when Settings.data_types_import.question
      header.include? Settings.collum_check_import.question
    end
  end

  def convert_to_hash model_attributes
    @verify_attributes.each do |attribute|
      @hash_verify_attributes =  @hash_verify_attributes.merge Hash[*[attribute.to_sym,
        model_attributes[attribute.to_sym]]]
    end
  end

  def import_question row
    question_name = row["name"]
    question_type = row["question_type"]
    priority = row["priority"]
    content = row["content"]
    correct = row["correct"]

    question = save_changes Question, {name: question_name},
      {name: question_name, class_room: @class_room, course: @class_room.course,
      priority: priority, question_type: question_type}
    save_changes Answer, {content: content, question_id: question.id},
      {question: question, content: content, correct: correct}
  end

  def save_changes model, fields_to_check, data
    if existed_model = model.find_by(fields_to_check)
      existed_model
    else
      model.create! data
    end
  end
end
