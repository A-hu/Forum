class Book < ApplicationRecord
	validates_presence_of :name

	belongs_to :user, optional: true
	belongs_to :category_id, optional: true
end
