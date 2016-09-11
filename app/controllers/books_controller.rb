class BooksController < ApplicationController

	before_action :authenticate_user!, except: [:index, :show]
	before_action :set_before, only: [:show, :edit, :update, :collection, :like, :subscribe, :destroy]
	before_action :security, only: [:edit, :update, :destroy]

	def index
			
		gon.tags = Tag.all.map{ |x| x.name }

		if params[:commit].present? && params[:commit] != "All"
			@books = Group.find_by_name(params[:commit]).books 
		else
			@books = Book.all
		end
			# if params[:commit] == "Comedy"
			#   @books = @books.where('groups.id' => 1)
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
		if params[:order].present?
			@books = @books.order("#{params[:order]} DESC")	
		else
			@books = @books.order("id DESC")
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
		
		if params[:commit] == "Create Book" 
			@book.update(is_public: true) 
			if @book.save
				flash[:notice] = "Add file success"
			    redirect_to book_path(@book, page: params[:page])
			else
				flash[:alert] = "Add fail"
				render 'edit'
			end
		elsif params[:commit] == "draft"
			if @book.save
				flash[:notice] = "Add file into draft"
			    redirect_to book_path(@book, page: params[:page])
			else
				flash[:alert] = "Add fail"
				render 'edit'
			end
		end
	end

	def edit
	end

	def update
			
		if params[:remove_img] == "1"
			@book.logo = nil
		end
		if params[:commit] == "Update Book"
			@book.update(is_public: true) 
			if @book.update(set_params)
				flash[:notice] = "Editted file success"
				redirect_to book_path(@book, page: params[:page])
			else
				flash[:alert] = "Editted fail"
				render 'edit'
			end
		elsif params[:commit] == "draft"
			if @book.update(set_params)
				flash[:notice] = "Editted file into draft"
				redirect_to book_path(@book, page: params[:page])
			else
				flash[:alert] = "Editted fail"
				render 'edit'
			end
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

	def like
		if current_user.liked_book?(@book)
			current_user.liked_books.delete(@book)
		else
			current_user.liked_books << @book
		end

		respond_to do |format|
		format.html {redirect_to book_path(@book)}
		format.js
		end
	end

	def subscribe
		if current_user.subscribed_books.exists?(@book.id)
			current_user.subscribed_books.delete(@book)
		else
			current_user.subscribed_books << @book
		end


		respond_to do |format|
		format.html {redirect_to books_path}
		format.js
		end
	end

	def destroy
		@book.destroy
		
		respond_to do |format|
			format.html {redirect_to books_path(page: params[:page])}
			format.js
		end
		
	end

	private

	def set_params
		params.require(:book).permit(:name, :description, :user_id, :comment_number, :category_id, :is_public, :logo, 
									 :onshelf_day, :tag_list, group_ids: [], book_ids: [])
	end

	def set_before
		@book = Book.find(params[:id])
	end

	def security
		if current_user != @book.user && current_user.role != "admin"
			flash[:alert] = "You are not allowed."
			redirect_to books_path
		end
	end
end
