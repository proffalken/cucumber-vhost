# This file is licensed under the GPL V. 2.0 or higher


#require the relevant libraries
require 'rubygems'
require 'libvirt'
require 'xmlrpc/client'
require 'net/ssh'
require 'ping'
require 'socket'
require 'timeout'
require 'yaml'

# setup the globals
Before do
    # load in the YAML config
    config_file = YAML::load(File.open('config.yml'))
    #cobbler server:
    @cobbler_server = config_file['cobbler']['server']
    @cobbler_port = config_file['cobbler']['port']

    #Libvirt
    @libvirt_driver = config_file['libvirt']['driver']
    @libvirt_host   = config_file['libvirt']['host']
    @libvirt_type   = config_file['libvirt']['type']
    @libvirt_storage_pool = config_file['libvirt']['storage_pool']


    ## VM Connection
    @vmconn =  Libvirt::open("#{@libvirt_driver}://#{@libvirt_host}/#{@libvirt_type}")
    ### VM Storage
    @vm_stor = @vmconn.lookup_storage_pool_by_name(@libvirt_storage_pool)   


    ## Cobbler API
    @cblr_api = XMLRPC::Client.new(@cobbler_server,"/cobbler_api",@cobbler_port)

    ### define the port-checker code
    def is_port_open(ip, port)
      begin
	Timeout::timeout(1) do
	  begin
	    s = TCPSocket.new(ip, port)
	    s.close
	    return true
	  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
	    return false
	  end
	end
      rescue Timeout::Error
      end

      return false
    end


end
