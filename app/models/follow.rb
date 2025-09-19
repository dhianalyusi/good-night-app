class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id, message: "already follow this user"  }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    return unless follower_id && followed_id

    if follower_id == followed_id
      errors.add(:base, "Followed cannot be the same as follower")
    end
  end
end
