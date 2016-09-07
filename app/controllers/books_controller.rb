class BooksController < ApplicationController

	before_action :authenticate_user!, except: [:index, :show]
	before_action :set_before, only: [:show, :edit, :update, :collection, :destroy]

	def index
			# if params[:commit] == "Comedy"
		if params[:commit].present? && params[:commit] != "All"
			@books = Group.find_by_name(params[:commit]).books 
		else
			@books = Book.all
		end
				# @books = @books.where('groups.id' => 1)
			# elsif params[:commit] == "Tragedy"
			# 	@books = @books.where('groups.id' => 2)
			# elsif params[:commit] == "NObody"
			# 	@books = @books.where('groups.id' => 3)
			# end
		# end
		@books = @books.where(is_public: true).includes(:groups)


		
			# if   == "update_time"
				# sort_by = "#{params[:order]} DESC"
			# elsif params[:order] == "ids"
			# 	sort_by = 'id ASC'
			# elsif params[:order] == "comments"
			# 	sort_by = 'comment_number DESC'
			# elsif params[:order] == "views"
			# 	sort_by = 'views DESC'
			# end
			@books = @books.order("#{params[:order]} DESC")	if params[:order].present?
		# end


		@books = @books.page( params[:page] ).per(10)

	end

	def show
		if params[:eid].present?
			@comment = @book.comments.find(params[:eid])
		else
			@comment = Comment.new
		end
		@book.views += 1
		# @user = current_user
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
			if params[:commit] == "Update Book"
				@book.update(is_public: true) 
				flash[:notice] = "Add file success"
			    redirect_to book_path(@book, page: params[:page])
			else
				flash[:notice] = "Add file into draft"
			    redirect_to book_path(@book, page: params[:page])
			end
		else
			flash[:alert] = "Add fail"
			render 'edit'
		end
	end

	def edit
	end

	def update

		if @book.update(set_params)	
			if params[:commit] == "Update Book"
			  @book.update(is_public: true) 
			  flash[:notice] = "Editted file success"
			  redirect_to book_path(@book, page: params[:page])
			else
			  flash[:notice] = "Editted file into draft"
			  redirect_to book_path(@book, page: params[:page])
			end
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
		if !current_user.collected_books.exists?(@book)
			current_user.collected_books << @book
			respond_to do |format|
				format.html {redirect_to user_path(current_user)}
				format.js
				end
		else
			flash[:alert] = "This book is already collected."
		end

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
