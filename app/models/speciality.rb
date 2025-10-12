class Speciality < ApplicationRecord
  belongs_to :exam
  validates :label, presence: true
end
