class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :confirmable, omniauth_providers: [:github, :twitter]

  has_many :authorisations, dependent: :destroy
  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :awards

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def self.find_by_authorisation(provider, uid)
    joins(:authorisations).where(authorisations: { provider: provider, uid: uid }).first
  end

  def self.build_twitter_auth_cookie_hash(data)
    {
      :provider => data.provider, :uid => data.uid.to_i,
      :access_token => data.credentials.token, :access_secret => data.credentials.secret
    }
  end

  def owner?(object)
    self.id == object.author_id
  end
end
