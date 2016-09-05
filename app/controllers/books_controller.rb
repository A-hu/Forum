class BooksController < ApplicationController

	before_action :authenticate_user!, except: [:index, :show]
	before_action :set_before, only: [:show, :edit, :update, :collection, :destroy]

	def index
		@users = User.all
		@books = Book.where(is_public: true).includes(:groups)

		if params[:commit].present?
			if params[:commit] == "Comedy"
				@books = @books.where('groups.id' => 1)
			elsif params[:commit] == "Tragedy"
				@books = @books.where('groups.id' => 2)
			elsif params[:commit] == "NObody"
				@books = @books.where('groups.id' => 3)
			end
		end

		if params[:order].present?
			if  params[:order] == "update_time"
				sort_by = {updated_at: :DESC}
			elsif params[:order] == "ids"
				sort_by = {id: :ASC}
			elsif params[:order] == "comments"
				sort_by = {comment_number: :DESC}
			elsif params[:order] == "views"
				sort_by = {views: :DESC}
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
		@book.views += 1
		@user = current_user
		@book.save
		@comments = @book.comments.where(is_public: true)
		@comments = @comments.page( params[:page] ).per(5)
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
		@book.views = 0
		if @book.save
			if params[:commit] == "draft"
				@book.update(is_public: false)
				flash[:notice] = "Added file into draft" 
			else
				@book.update(is_public: true)
				flash[:notice] = "Added success"
			end
			
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
			if params[:commit] == "draft"
				@book.update(is_public: false)
				flash[:notice] = "Editted file into draft" 
			else
				@book.update(is_public: true)
				flash[:notice] = "Editted success"
			end
			
			redirect_to book_path(@book, page: params[:page])
		else
			flash[:alert] = "Editted fail"
			render 'edit'
		end
	end

	def collection
		# @userbookship = UserBookship.create(
		# 	:user_id => current_user.id,
		# 	:book_id => @book.id
		# 	)
		current_user.collected_books << @book

		redirect_to user_path(current_user)
	end

	def destroy
		@book.destroy
		flash[:alert] = "Delete success"
		redirect_to books_path(page: params[:page])
	end

	private

	def set_params
		params.require(:book).permit(:name,:description, :user_id, :comment_number, :category_id, :is_public,
									 group_ids: [], book_ids: [])
	end

	def set_before
		@book = Book.find(params[:id])
	end
end
