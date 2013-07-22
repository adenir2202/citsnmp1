class CommentsController < ApplicationController

	def create
  		@comment = Comment.new(comment_params)
  		@comment.comment_id = params[:comment_id]

  		@comment.save

		flash.notice = "O comentário [#{@comment.title}] foi criado!"
  		redirect_to comment_path(@comment.comment)
	end

	def comment_params
  		params.require(:comment).permit(:author_name, :body)
	end


	def index
  		@comments = Article.all
	end

	def show
		@comment = Article.find(params[:id])
	end

	def new
		@comment = Article.new
	end

	def destroy
  		@comment = Article.find(params[:id])	
  		@comment = Article.destroy(params[:id])	
		#@comment.save
		flash.notice = "O comentário [#{@comment.title}] foi excluido!"
  		redirect_to comment_path(@comment.find(0))
	end


	def edit
  		@comment = Article.find(params[:id])
	end

	def update
  		@comment = Article.find(params[:id])
  		@comment.update(comment_params)

		flash.notice = "O comentário [#{@comment.title}] foi modificado!"

  		redirect_to comment_path(@comment)
	end	

end
