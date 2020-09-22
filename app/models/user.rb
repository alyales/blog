class User < ActiveRecord::Base

  validates :login, presence: true,
                    uniqueness: true

  has_many :posts
  has_and_belongs_to_many :ips

  def self.find_by_login(login)
    self.find_by(login: login)
  end
end
