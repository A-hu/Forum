class BooksController < ApplicationController

	before_action :authenticate_user!, except: [:index, :show]
	before_action :set_before, only: [:show, :edit, :update, :destroy]

	def index
		@users = User.all
		@books = Book.all
		if params[:commit].present?
			if params[:commit] == "Comedy"
				@books = Book.includes(:groups).where('groups.id' => 1)
			elsif params[:commit] == "Tragedy"
				@books = Book.includes(:groups).where('groups.id' => 2)
			elsif params[:commit] == "NObody"
				@books = Book.includes(:groups).where('groups.id' => 3)
			else
				@books = Book.all
			end
		end

		if params[:order].present?
			if  params[:order] == "update_time"
				sort_by = {updated_at: :DESC}
			elsif params[:order] == "ids"
				sort_by = {id: :ASC}
			elsif params[:order] == "comments"
				sort_by = {comment_number: :DESC}
			else
				@books = Book.all
			end
			@books = @books.order(sort_by)	
		end


		@books = @books.page( params[:page] ).per(10)

	end

	def show
		if params[:eid].present?
			@comment = @book.comments.find(params[:eid])
		else
			@comment = Comment.new
		end
		@comments = @book.comments.page( params[:page] ).per(10)
	end

	def about
		@users = User.all
		@books = Book.all
		@comments = Comment.all
	end

	def new
		@book = Book.new
	end

	def create
		@book = Book.new(set_params)
		@book.user = current_user
		@book.comment_number = 0
		if @book.save
			flash[:notice] = "Added success"
			redirect_to book_path(@book, page: params[:page])
		else
			flash[:alert] = "Added fail"
			render 'new'
		end
	end

	def edit
	end

	def update
		if @book.update(set_params)
			flash[:notice] = "Editted success"
			redirect_to book_path(@book, page: params[:page])
		else
			flash[:alert] = "Editted fail"
			render 'edit'
		end
	end

	def destroy
		@book.destroy
		flash[:alert] = "Delete success"
		redirect_to books_path(page: params[:page])
	end

	private

	def set_params
		params.require(:book).permit(:name,:description, :user_id, :comment_number, :category_id,
									 group_ids: [])
	end

	def set_before
		@book = Book.find(params[:id])
	end
end
