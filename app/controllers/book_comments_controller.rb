class BookCommentsController < ApplicationController



	before_action :find_book
	before_action :set_before, only: [:show, :edit, :update, :destroy]

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
		@comment = @book.comments.new(set_params)
		@comment.user = current_user
		@book.comment_number += 1
		if @comment.save && @book.save
			flash[:notice] = "Add comment success"
			redirect_to book_path(@book, page: params[:page])
		else
			flash[:alert] = "Add comment fail"
			render 'index'
		end
	end

	# def edit
	# end

	def update
		if @comment.update(set_params)
			flash[:notice] = "Edit comment success"
			redirect_to book_path(@book, page: params[:page])
		else
			flash[:alert] = "Edit comment fail"
			render 'index'
		end
	end

	def destroy
		@comment.destroy
		flash[:alert] = "Delete success"
		redirect_to book_path(@book)
	end


	private

	def find_book
		@book = Book.find(params[:book_id])
	end

	def set_before
		@comment = @book.comments.find(params[:id])
	end

	def set_params
		params.require(:comment).permit(:description, :user_id)
	end
end
