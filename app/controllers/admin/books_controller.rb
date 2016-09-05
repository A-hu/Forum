class Admin::BooksController < ApplicationController

    before_action :authenticate_user!
    layout "admin"

    def index
    	@books = Book.all
    	@users = User.all
    end

    protected


end
