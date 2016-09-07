class UsersController < ApplicationController
	
	before_action :set_before, except: [:index, :new, :create]

	def index
		
	end

	def show
		@publicbooks = @user.owner_books.where(is_public: true)
		@draftbooks = @user.owner_books.where(is_public: false)
		@publiccomments = @user.comments.where(is_public: true)
		@draftcomments = @user.comments.where(is_public: false)
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(set_params)
	end

	def edit
	end

	def update
		@user.update(set_params)
		redirect to user_path(@user)
	end
 
	private

	def set_before
		@user = User.find(params[:id])
	end

	def set_params
		params.require(:user).permit(:role)
	end
end
