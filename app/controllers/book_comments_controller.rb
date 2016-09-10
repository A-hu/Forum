class BookCommentsController < ApplicationController


	before_action :authenticate_user!
	before_action :find_book
	before_action :set_before, only: [:show, :edit, :update, :destroy]
	before_action :security, only: [:edit, :update, :destroy]
	def index

		# if params[:eid].present?
		# 	@comment = @book.comments.find(params[:eid])
		# else
		# 	@comment = Comment.new
		# end

		# @comments = @book.comments.page( params[:page] ).per(5)
	end

	def show
	end

	# def new
	# 	@comment = Comment.new 
	# end

	def create
		@comment = Comment.new(set_params)
		@comment.update(book_id: params[:book_id])
		@comment.user = current_user
		@book.comment_number += 1
		@book.save
		
		if params[:commit] == "Create Comment"
			@comment.update(is_public: true) 
			if @comment.save
				flash[:notice] = "Add comment success"
			else
				flash[:alert] = "Add comment fail"
				redirect_to book_path(@book)
			end
		elsif params[:commit] == "draft"
			if @comment.save
				flash[:notice] = "Add comment into draft"	
				redirect_to book_path(@book)	
			else
				flash[:alert] = "Add comment fail"
				redirect_to book_path(@book)
			end
		end	

		respond_to do |format|
			format.html {redirect_to book_path(@book)}
			format.js
		end
	end

	# def edit
	# end

	def update	
		if params[:remove_img] == "1"
			@comment.logo = nil
		end	

		if params[:commit] == "Update Comment"
			@comment.update(is_public: true) 
			if @comment.update(set_params)
				flash[:notice] = "Editted comment success"
				redirect_to book_path(@book, page: params[:page])
			else
				flash[:alert] = "Edit comment fail"
				redirect_to book_path(@book)
			end
		elsif params[:commit] == "draft"
			if @comment.update(set_params)
				flash[:notice] = "Editted comment into draft"
				redirect_to book_path(@book, page: params[:page])
			else
				flash[:alert] = "Edit comment fail"
				redirect_to book_path(@book)
			end
		end
	end

	def destroy
		@book.comment_number -= 1
		@book.save
		@comment.destroy

		respond_to do |format|
			format.html {redirect_to book_path(@book)}
			format.js
		end
		
	end


	private

	def find_book
		@book = Book.find(params[:book_id])
	end

	def set_before
		@comment = Comment.find(params[:id])
	end

	def set_params
		params.require(:comment).permit(:description, :user_id, :is_public, :logo)
	end

	def security
		if current_user != @comment.user && current_user.role != "admin"
			flash[:alert] = "You are not allowed."
			redirect_to books_path
		end
	end
end
