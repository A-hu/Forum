class Group < ApplicationRecord
	validates_presence_of :name

	has_many :book_groupships
	has_many :books, through: :book_groupships
end
