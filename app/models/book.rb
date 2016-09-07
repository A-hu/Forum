class Book < ApplicationRecord
	validates_presence_of :name

	belongs_to :user, optional: true
	belongs_to :category, optional: true

	has_many :comments, :dependent => :destroy
	has_many :book_groupships
	has_many :groups, through: :book_groupships

	has_many :user_bookships
	has_many :users, through: :user_bookships

	def user_uniq
		list=[]
		self.comments.each do |comment|
			list << comment.user.short_name
		end
			list = list.uniq
	end
end

