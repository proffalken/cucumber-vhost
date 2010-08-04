# This file is licensed under the GPL V. 2.0 or higher


#require the relevant libraries
require 'rubygems'
require 'libvirt'
require 'xmlrpc/client'
require 'net/ssh'
require 'ping'
require 'socket'
require 'timeout'

# setup the globals
Before do
#cobbler server:
@cobbler_server = "localhost"
@cobbler_port = "80"

#Libvirt
@libvirt_driver = "qemu" # can be any of qemu, vbox, xen, openvz, one, esx, gsx as detailed on the libvirt wiki
@libvirt_host = ""
@libvirt_type = "system"
@libvirt_storage_pool = "default"


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
