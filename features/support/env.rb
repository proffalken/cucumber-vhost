# This file is licensed under the GPL V. 2.0 or higher


#require the relevant libraries
require 'rubygems'
require 'libvirt'
require 'xmlrpc/client'
require 'net/ssh'
require 'ping'

# setup the globals
Before do
#cobbler server:
@cobbler_server = "localhost"
@cobbler_port = "80"

#Libvirt
@libvirt_driver = "qemu" # can be any of qemu, vbox, xen, openvz, one, esx, gsx as detailed on the libvirt wiki
@libvirt_host = ""
@libvirt_type = "system"
@libvirt_storage_pool = "VBox"


## VM Connection
@vmconn =  Libvirt::open("#{@libvirt_driver}://#{@libvirt_host}/#{@libvirt_type}")
### VM Storage
@vm_stor = @vmconn.lookup_storage_pool_by_name(@libvirt_storage_pool)   


## Cobbler API
@cblr_api = XMLRPC::Client.new(@cobbler_server,"/cobbler_api",@cobbler_port)

end
