class SyllabusForm < Reform::Form

  property :course_id
  property :title
  property :week
  validate :validate_syllabus_detail_title
  validate :uniq_by_week

  collection :syllabus_details, populate_if_empty: SyllabusDetail do
    property :id, writeable: false
    property :title
    property :_destroy, writeable: false
  end

  def save
    super do |attrs|
      if model.persisted?
        # remove
        to_be_removed = ->(i) {i[:_destroy] == "1"}
        syllabus_detail_ids_to_rm = attrs[:syllabus_details].select(&to_be_removed).map {|i| i[:id]}
        SyllabusDetail.destroy syllabus_detail_ids_to_rm
        syllabus_details.reject! {|i| syllabus_detail_ids_to_rm.include? i.id}

        # reject
        syllabus_details.reject! {|i| i.title.blank?}
      else
        syllabus_details.reject! {|i| i.title.blank?}
      end
    end

    super
  end

  def validate_syllabus_detail_title
    syllabus_details.each do |syllabus_detail|
      if SyllabusDetail.find_by_id(syllabus_detail.id).present? && syllabus_detail.title.blank?
        errors.add :syllabus_detail_title, I18n.t("flashs.messages.cannot_blank")
      end
    end
  end

  def uniq_by_week
    if !model.persisted? && model.course.syllabuses.map(&:week).include?(week.to_i)
      errors.add :week, I18n.t("syllabuses.errors.week_existed", week: week)
    end
  end
end
