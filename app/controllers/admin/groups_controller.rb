class Admin::GroupsController < ApplicationController

	before_action :is_admin
	before_action :authenticate_user!
	before_action :find_group, except: [:index, :create]

	def index
		if params[:gid].present?
			@group = Group.find(params[:gid])
		else
			@group = Group.new
		end

		@groups = Group.all
	end

	def create
		@group = Group.new(set_params)
		@group.save
		redirect_to admin_groups_path
	end

	def update
		@group.update(set_params)
		redirect_to admin_groups_path
	end

	def destroy
		 if !@group.books.present?
		 	@group.destroy
		 	redirect_to admin_groups_path
		 else
			flash[:alert] = "This is not allowed!!!"
			redirect_to admin_groups_path
		 end
		
	end

	private

	def find_group
		@group = Group.find(params[:id])
	end

	def set_params
		params.require(:group).permit(:name)
	end

	def is_admin
      unless  current_user.role == "admin"
          redirect_to root_path
          return
      end
    end 
end
