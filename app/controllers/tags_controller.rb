class TagsController < ApplicationController


	def index
  		@tags = Article.all
	end

	def show
		@tag = Article.find(params[:id])
	end

	def new
		@tag = Article.new
	end

	def create
  		@tag = Article.new(tag_params)	
		@tag.save
		flash.notice = "O artigo [#{@tag.title}] foi criado!"
  		redirect_to tag_path(@tag)
	end

	def destroy
  		@tag = Article.find(params[:id])	
  		@tag = Article.destroy(params[:id])	
		#@tag.save
		flash.notice = "O artigo [#{@tag.title}] foi excluido!"
  		redirect_to tag_path(@tag.find(0))
	end

  	def tag_params
    		params.require(:tag).permit(:title, :body, :tag_list)
  	end

	def edit
  		@tag = Article.find(params[:id])
	end

	def update
  		@tag = Article.find(params[:id])
  		@tag.update(tag_params)

		flash.notice = "O artigo [#{@tag.title}] foi modificado!"

  		redirect_to tag_path(@tag)
	end
	
end
