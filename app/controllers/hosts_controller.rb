require 'snmp'

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
  	
  	@host.hostName = "adenir.centralit"
  	@host.save
  	flash.notice = "O Host [#{@host.hostName} #{@host.description} #{@host.snmp_userName}] foi criado!"
  	redirect_to host_path(@host)
  end
  
  def destroy
    @host = Host.find(params[:id])

    @host.destroy
    flash.notice = "O host [#{@host.hostName}] foi excluido!"

    redirect_to hosts_path
  end

  def host_params
  		params.require(:host).permit(:hostName, :description, :snmp_community, :snmp_version, :snmp_userName, :snmp_password)    

  end
    
  def edit
  	@host = Host.find(params[:id])
    SNMP::Manager.open(:host => 'localhost') do |manager|
        response = manager.get(["sysDescr.0", "sysName.0"])
        response.each_varbind do |vb|
            @host.hostName = vb.name.to_s
            @host.description = vb.value.to_s
            @host.snmp_userName = vb.value.asn1_type
        end
    end
  end
  
  def update
  	@host = Host.find(params[:id])
  	@host.update(host_params)
  
    flash.notice = "O Host [#{@host.hostName}] foi modificado!"
  
  	redirect_to host_path(@host)
  end

  def listAllHost
    #arp-scan --interface=eth0 192.168.0.0/24
    #!/bin/bash
    #for ip in 192.168.0.{1..254}; do
      #  ping -c 1 -W 1 $ip | grep "64 bytes" &
    #done
    
    @host = Host.new
    SNMP::Manager.open(:host => 'localhost') do |manager|
        response = manager.get(["sysDescr.0", "sysName.0"])
        response.each_varbind do |vb|
            @host.hostName = vb.name.to_s
            @host.description = vb.value.to_s
            @host.snmp_userName = vb.value.asn1_type
            flash.notice = "O Host [#{@host.hostName} #{@host.description} #{@host.snmp_userName}] foi criado!"
        end
    end
    
    render :action => "new"
   end 
end