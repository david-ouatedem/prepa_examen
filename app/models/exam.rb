class Exam < ApplicationRecord
  self.primary_key = :id
  validates :label, presence: true
  has_many :specialities, dependent: :destroy
end
