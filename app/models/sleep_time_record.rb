class SleepTimeRecord < ApplicationRecord
  belongs_to :user

  validates :sleep_time, presence: true
  validate :wake_time_check

  private

  def wake_time_check
    if wake_time.present? && wake_time <= sleep_time
      errors.add(:wake_time, "must be after sleep time")
    end
  end

end
