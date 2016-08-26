class Comment < ApplicationRecord
	validates_presence_of :description

	belongs_to :book
	belongs_to :user
end
