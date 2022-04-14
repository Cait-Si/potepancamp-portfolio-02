class Post < ApplicationRecord
  belongs_to :user
  has_many :messages

  validates :title, :person, :datetime, :location, :level, :description, :deadline, presence: true
end
