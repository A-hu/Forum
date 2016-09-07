class Admin::UsersController < ApplicationController
	before_action :is_admin
	before_action :authenticate_user!

	def index
		if params[:pass].present?
			@user = User.find(params[:pass])
			@user.update(role: "admin")
		end

		@users = User.all
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		@user.update(strong_params)
		redirect_to admin_users_path
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
		redirect_to admin_users_path
	end




	private

	def strong_params
		params.require(:user).permit(:introduction, :role)
	end

	def is_admin
      unless  current_user.role == "admin"
          redirect_to root_path
          return
      end
    end 
end
