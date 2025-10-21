class Subject < ApplicationRecord
  has_and_belongs_to_many :specialities
  has_one_attached :file
  validates :label, presence: true
  validates :year, presence: true
  validates :file, content_type: ['application/pdf'],
            size: { less_than: 10.megabytes, message: "doit être inférieur à 10 Mo" }
end
