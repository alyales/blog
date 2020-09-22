class Ip < ActiveRecord::Base

  validates :address, presence: true,
                      uniqueness: true
  has_many :posts
  has_and_belongs_to_many :users

  scope :with_users, -> (ids) { where(id: ids).joins(:users).includes(:users) }

  def self.find_by_address(address)
    self.find_by(address: address)
  end
end
