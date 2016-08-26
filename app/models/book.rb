class Book < ApplicationRecord
	validates_presence_of :name

	belongs_to :user, optional: true
	belongs_to :category_id, optional: true

	has_many :comments
	has_many :book_groupships
	has_many :groups, through: :book_groupships
end
