class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true
  validates :user, uniqueness: { scope: [:votable_id, :votable_type], message: 'can vote only once for each object' }
  validate :authorship

  def self.cancel(user, votable)
    find_by(user: user, votable_type: votable.class.name, votable_id: votable.id)&.destroy
  end

  private

  def authorship
    errors.add(:author, 'can not vote for himself') if user && user.owner?(votable)
  end
end
