class Admin::BooksController < ApplicationController

    before_action :authenticate_user!
    before_action :is_admin
    layout "admin"

    def index
    	@books = Book.all
    	@users = User.all
    end

    protected

    def is_admin
      unless  current_user.role == "admin"
          redirect_to root_path
          return
      end
    end    


end
