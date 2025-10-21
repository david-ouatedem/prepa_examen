class Subject < ApplicationRecord
  has_and_belongs_to_many :specialities
  validates :label, presence: true
end
