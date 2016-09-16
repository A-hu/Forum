class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :owner_books , :class_name => "Book" , :foreign_key => "user_id", :dependent => :destroy
  has_many :comments , :dependent => :destroy

  has_many :user_bookships
  has_many :collected_books, through: :user_bookships, :source => :book


  has_many :likes, :dependent => :destroy
  has_many :liked_books, through: :likes, :source => :book

  has_many :subscribes, dependent: :destroy
  has_many :subscribed_books, through: :subscribes, source: :book

  has_many :friendships
  has_many :friends, ->{ where( "friendships.status" => "confirmed") }, :through => :friendships

  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, ->{ where( "friendships.status" => "confirmed") }, :through => :inverse_friendships, :source => "user"
  
  def short_name
  	self.email.split("@").first
  end

  def liked_book?(book)
    self.liked_books.include?(book)
  end

  def self.from_facebook_omniauth(auth)
     # Case 1: Find existing user by facebook uid
     user = User.find_by_fb_uid( auth.uid )
     if user
        user.fb_token = auth.credentials.token
        #user.fb_raw_data = auth
        user.save!
       return user
     end

     # Case 2: Find existing user by email
     existing_user = User.find_by_email( auth.info.email )
     if existing_user
       existing_user.fb_uid = auth.uid
       existing_user.fb_token = auth.credentials.token
       #existing_user.fb_raw_data = auth
       existing_user.save!
       return existing_user
     end

     # Case 3: Create new password
     user = User.new
     user.fb_uid = auth.uid
     user.fb_token = auth.credentials.token
     user.email = auth.info.email
     user.password = Devise.friendly_token[0,20]
     #user.fb_raw_data = auth
     user.save!
     return user
   end

  def all_friends
    (friends + inverse_friends).uniq
  end

  def find_friendship(user)
    friendships.where( :friend => user ).first ||
    user.friendships.where( :friend => self ).first
  end

  def is_friend?(user)
    all_friends.include?(user)
  end

  def pending_friendship?(user)
    self.friendships.pending.where( :friend => user ).exists?
  end

  def inverse_pending_friendship?(user)
    user.friendships.pending.where( :friend => self ).exists?
  end

  def ignored_friendship?(user)
    self.friendships.ignored.where( :friend => user ).exists?
  end

  def inverse_ignored_friendship?(user)
    user.friendships.ignored.where( :friend => self ).exists?
  end
end
