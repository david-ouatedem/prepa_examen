class Subject < ApplicationRecord
  has_and_belongs_to_many :specialities
  has_one_attached :file
  validates :label, presence: true
  validates :year, presence: true
  validates :file, content_type: ['application/pdf'],
            size: { less_than: 10.megabytes, message: "doit être inférieur à 10 Mo" }

  def self.filter(params)
    subjects = all

    if params[:speciality_id].present?
      subjects = subjects.joins(:specialities)
                         .where(specialities: { id: params[:speciality_id] })
    end

    if params[:exam_id].present?
      subjects = subjects.joins(:specialities)
                         .where(specialities: { exam_id: params[:exam_id] })
    end

    if params[:year].present?
      subjects = subjects.where(year: params[:year].to_i)
    end

    subjects.distinct
  end
end
