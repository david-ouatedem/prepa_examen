class Speciality < ApplicationRecord
  belongs_to :exam
  has_and_belongs_to_many :subjects
  validates :label, presence: true
end
