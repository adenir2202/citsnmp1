class ArticlesController < ApplicationController
	def index
  		@articles = Article.all
	end

	def show
		@article = Article.find(params[:id])
		@comment = Comment.new
		@comment.article_id = @article.id
	end
	
	def new
		@article = Article.new
		@comment = Comment.new
		@comment.article_id = @article.id
	end

	def create
  		@article = Article.new(article_params)	
		@article.save
		flash.notice = "O artigo [#{@article.title}] foi criado!"
  		redirect_to article_path(@article)
	end

	def destroy
  		@article = Article.find(params[:id])	
  		@article = Article.destroy(params[:id])	
		#@article.save
		flash.notice = "O artigo [#{@article.title}] foi excluido!"
  		redirect_to article_path(@article.find(0))
	end

  	def article_params
    		params.require(:article).permit(:title, :body, :tag_list)
  	end

	def edit
  		@article = Article.find(params[:id])
	end

	def update
  		@article = Article.find(params[:id])
  		@article.update(article_params)

		flash.notice = "O artigo [#{@article.title}] foi modificado!"

  		redirect_to article_path(@article)
	end
end
