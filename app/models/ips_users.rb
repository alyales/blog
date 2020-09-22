class IpsUsers < ActiveRecord::Base

  THRESHOLD_USERS_COUNT = 1

  validates_uniqueness_of :ip_id, scope: :user_id

  scope :with_several_users, -> { group(:ip_id).having("count(*) > #{THRESHOLD_USERS_COUNT}") }

end
