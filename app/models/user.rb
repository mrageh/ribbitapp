class User < ActiveRecord::Base
  before_validation :prep_email
  before_save :create_avatar_url

  has_many :follower_relationships, classname: "Relationship", foreign_key: "followed_id"
  has_many :followed_relationships, classname: "Relationship", foreign_key: "follower_id"


  has_many :ribbits

  has_secure_password

  validates :name, presence: true
  validates :username, uniqueness: true, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, uniqueness: true, presence: true, format: { with: VALID_EMAIL_REGEX  }

  def following? user
    self.followeds.include? user
  end

  def follow user
      Relationship.create follower_id: self.id, followed_id: user.id
  end

  private

  def prep_email
    self.email = self.email.strip.downcase if self.email
  end
  def create_avatar_url
    self.avatar_url = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}?s=50"
  end
end
