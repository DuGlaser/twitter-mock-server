class Tweet < ApplicationRecord
  belongs_to :user
  default_scope -> { order(create_at: :desc) }
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, length: { maximum: 140 }
  validates :picture_size

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
