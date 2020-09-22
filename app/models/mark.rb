class Mark < ActiveRecord::Base

  validates :mark, presence: true,
                   numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  belongs_to :post

  before_save :update_avg_mark, if: -> { mark_changed? }

  def update_avg_mark
    self.post.update_post_avg_mark(self.mark)
  end

end
