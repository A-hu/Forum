class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :owner_books , :class_name => "Book" , :foreign_key => "user_id"
  has_many :comments

  has_many :user_bookships
  has_many :collected_books, through: :user_bookships, :source => :book

  def short_name
  	self.email.split("@").first
  end
end
