class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate :correct_url

  def correct_url
    unless url =~ /\A#{URI::regexp(['http', 'https'])}\z/
      errors.add(:invalid_url, 'must have url format')
    end
  end

  def gist?
    url =~ /gist.github.com/
  end
end
