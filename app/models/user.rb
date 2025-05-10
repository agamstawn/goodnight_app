class User < ApplicationRecord
  has_many :sleep_time_records, dependent: :destroy
end
