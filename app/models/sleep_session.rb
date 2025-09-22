class SleepSession < ApplicationRecord
  belongs_to :user

  validates :sleep_at, presence: true
end
