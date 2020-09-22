class Post < ActiveRecord::Base

  validates :title, :body, presence: true

  belongs_to :ip
  belongs_to :user

  scope :top_by_avg_mark, -> (n) { order('avg_mark DESC NULLS LAST').limit(n) }

  before_create :add_ips_user

  def update_post_avg_mark(new_mark)
    new_avg_mark = (self.marks_count * (self.avg_mark || 0.0) + new_mark) / (self.marks_count + 1)
    self.update!(avg_mark: new_avg_mark, marks_count: self.marks_count + 1)
  end

  def add_ips_user
    IpsUsers.create(ip_id: self.ip_id, user_id: self.user_id)
  end
end
