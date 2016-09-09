class Book < ApplicationRecord
	validates_presence_of :name

	belongs_to :user, optional: true
	belongs_to :category, optional: true

	has_many :comments, :dependent => :destroy
	has_many :book_groupships, :dependent => :destroy
	has_many :groups, through: :book_groupships

	has_many :user_bookships
	has_many :users, through: :user_bookships

	has_many :likes, :dependent => :destroy
	has_many :likers, :through => :likes, :source => :user

	has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/
	
	def user_uniq
		list=[]
		self.comments.each do |comment|
			list << comment.user.short_name
		end
			list = list.uniq
	end
end

