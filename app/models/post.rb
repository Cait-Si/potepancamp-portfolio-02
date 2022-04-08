class Post < ApplicationRecord
  has_many :messages

  validates :title, :person, :datetime, :location, :level, :description, :deadline, presence: true
end
