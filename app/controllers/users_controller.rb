class UsersController < ApplicationController
	
	before_action :set_before

	def show
		@books = @user.owner_books.where(is_public: false)
		@comments = @user.comments.where(is_public: false)
	end

	def edit
	end

	def update
		@user.update
		redirect to user_path(@user)
	end
 
	private

	def set_before
		@user = User.find(params[:id])
	end
end
