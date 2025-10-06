class Exam < ApplicationRecord
  self.primary_key = :id
  validates :label, presence: true
end
