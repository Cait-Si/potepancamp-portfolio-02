class Post < ApplicationRecord
  belongs_to :user
  has_many :messages

  validates :title, :person, :datetime, :location, :level, :description, :deadline, presence: true
  validate :date_before_start
  validate :date_before_finish

  scope :by_date, -> { where(datetime: Date.today..).order(datetime: :desc) }

  def date_before_start
    return if datetime.blank?
    errors.add(:datetime, "は今日以降のものを選択してください。") if datetime < Date.today
  end

  def date_before_finish
    return if datetime.blank? || deadline.blank?
    errors.add(:deadline, "は開始日前のものを選択してください") if datetime < deadline
  end
end
