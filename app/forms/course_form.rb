class CourseForm < Reform::Form
  property :name
  property :uid
  property :description
  property :theory_duration
  property :exercise_duration
  property :practice_duration
  property :weight
  property :base_hours
  property :evaluation
  validate :validate_reference_name

  collection :course_references, populate_if_empty: CourseReference do
    property :id, writeable: false
    property :name
    property :_destroy, writeable: false
  end

  def save
    super do |attrs|
      if model.persisted?
        # remove
        to_be_removed = ->(i) {i[:_destroy] == "1"}
        course_reference_ids_to_rm = attrs[:course_references].select(&to_be_removed).map {|i| i[:id]}
        CourseReference.destroy course_reference_ids_to_rm
        course_references.reject! {|i| course_reference_ids_to_rm.include? i.id}

        # reject
        course_references.reject! {|i| i.name.blank?}
      else
        course_references.reject! {|i| i.name.blank?}
      end
    end

    super
  end

  def validate_reference_name
    course_references.each do |reference|
      if CourseReference.find_by_id(reference.id).present? && reference.name.blank?
        errors.add :reference, I18n.t("flashs.messages.cannot_blank")
      end
    end
  end
end
