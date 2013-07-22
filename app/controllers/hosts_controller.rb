class HostsController < ApplicationController
	def index
  		@hosts = Host.all
	end

	def show
		@host = Host.find(params[:id])
	end
	
	def new
		@host = Host.new
	end

	def create
  		@host = Host.new(host_params)	
		@host.save
		flash.notice = "O Host [#{@host.hostName}] foi criado!"
  		redirect_to host_path(@host)
	end

	def destroy
  		@host = Host.find(params[:id])	
  		@host = Host.destroy(params[:id])	
		#@host.save
		flash.notice = "O Host [#{@host.hostName}] foi excluido!"
  		redirect_to host_path(@host.find(0))
	end

  	def host_params
    		params.require(:host).permit(:hostName, :body, :tag_list)
  	end

	def edit
  		@host = Host.find(params[:id])
	end

	def update
  		@host = Host.find(params[:id])
  		@host.update(host_params)

		flash.notice = "O Host [#{@host.hostName}] foi modificado!"

  		redirect_to host_path(@host)
	end

end
