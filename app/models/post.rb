class Post < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :title, :person, :datetime, :address, :level, :description, :deadline, :post_image, :end_datetime, presence: true
  validate :date_before_start
  validate :date_before_finish
  validate :date_before_deadline

  mount_uploader :post_image, PostImageUploader

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  scope :by_date, -> { where(datetime: Date.today..).order(datetime: :asc) }

  def date_before_start
    return if datetime.blank?
    errors.add(:datetime, "は今日以降のものを選択してください。") if datetime < Date.today
  end

  def date_before_finish
    return if datetime.blank? || end_datetime.blank?
    errors.add(:end_datetime, "は開始日時以降のものを選択してください。") if end_datetime < datetime
  end

  def date_before_deadline
    return if datetime.blank? || deadline.blank?
    errors.add(:deadline, "は開始日時前のものを選択してください") if datetime < deadline
  end
end
