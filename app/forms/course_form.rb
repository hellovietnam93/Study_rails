class CourseForm < Reform::Form
  include Reform::Form::ActiveModel::ModelReflections

  property :name
  property :uid
  property :description
  property :theory_duration
  property :exercise_duration
  property :practice_duration
  property :weight
  property :base_hours
  property :evaluation

  collection :course_references, populate_if_empty: CourseReference, reject_if: lambda {|fragment| fragment["name"].blank?} do
    property :id, writeable: false
    property :name
    property :_destroy, writeable: false
  end

  collection :syllabuses, populate_if_empty: Syllabus, reject_if: lambda {|fragment| fragment["title"].blank?} do
    property :id, writeable: false
    property :week
    property :title
    property :_destroy, writeable: false

    collection :syllabus_details, populate_if_empty: SyllabusDetail, reject_if: lambda {|fragment| fragment["title"].blank?} do
      property :id, writeable: false
      property :title
      property :_destroy, writeable: false
    end
  end

  def save
    # you might want to wrap all this in a transaction
    super do |attrs|
      if model.persisted?
        to_be_removed = ->(i) {i[:_destroy] == "1"}
        # course references
        course_reference_ids_to_rm = attrs[:course_references].select(&to_be_removed).map {|i| i[:id]}

        CourseReference.destroy course_reference_ids_to_rm
        course_references.reject! {|i| course_reference_ids_to_rm.include? i.id}

        # syllabuses
        syllabus_ids_to_rm = attrs[:syllabuses].select(&to_be_removed).map {|i| i[:id]}

        Syllabus.destroy syllabus_ids_to_rm
        syllabuses.reject! {|i| syllabus_ids_to_rm.include? i.id}

        # syllabus details
        syllabuses.each do |syllabus|
          sd_to_be_removed = []
          syllabus.syllabus_details.each do |syllabus_detail|
            sd_to_be_removed << syllabus_detail.id if syllabus_detail._destroy == "1"
          end

          SyllabusDetail.destroy sd_to_be_removed
          syllabus.syllabus_details.reject! {|sd| sd_to_be_removed.include? sd.id}
        end

        # reject
        to_be_reject = ->(i) do
          i[:name].blank? && CourseReference.find_by_id(i[:id]).nil?
        end

        course_reference_ids_to_rf = attrs[:course_references].select(&to_be_reject).map {|i| i[:id]}
        course_references.reject! {|i| course_reference_ids_to_rf.include? i.id}

        to_be_reject = ->(i) do
          i[:title].blank? && Syllabus.find_by_id(i[:id]).nil?
        end
        syllabus_ids_to_rf = attrs[:syllabuses].select(&to_be_reject).map {|i| i[:id]}

        syllabuses.reject! {|i| syllabus_ids_to_rf.include? i.id}

        syllabuses.each do |syllabus|
          sd_to_be_reject = []
          syllabus.syllabus_details.each do |syllabus_detail|
            sd_to_be_reject << syllabus_detail.id if syllabus_detail.title.blank?
          end

          syllabus.syllabus_details.reject! {|sd| sd_to_be_reject.include? sd.id}
        end
      else
        to_be_reject = ->(i) {i[:name].blank?}

        course_reference_ids_to_rf = attrs[:course_references].select(&to_be_reject).map {|i| i[:id]}
        course_references.reject! {|i| course_reference_ids_to_rf.include? i.id}

        to_be_reject = ->(i) {i[:title].blank?}
        syllabus_ids_to_rf = attrs[:syllabuses].select(&to_be_reject).map {|i| i[:id]}

        syllabuses.reject! {|i| syllabus_ids_to_rf.include? i.id}

        syllabuses.each do |syllabus|
          sd_to_be_reject = []
          syllabus.syllabus_details.each do |syllabus_detail|
            sd_to_be_reject << syllabus_detail.id if syllabus_detail.title.blank?
          end

          syllabus.syllabus_details.reject! {|sd| sd_to_be_reject.include? sd.id}
        end
      end
    end

    # this time actually save
    super
  end
end
