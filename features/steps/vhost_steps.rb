#require the relevant libraries
require 'rubygems'
require 'libvirt'
require 'xmlrpc/client'
require 'net/ssh'
require 'net/ping'

# setup the globals

#cobbler server:
@cobbler_server = "localhost"
@cobbler_port = "80"

#Libvirt
@libvirt_host = ""
@libvirt_type = "system"


## VM Connection
@vmconn =  Libvirt::open("qemu://#{@libvirt_host}/#{@libvirt_type}")

## Cobbler API
@cblr_api = XMLRPC::Client.new(@cobbler_server,"/cobbler_api",@cobbler_port)

Given /^that I want to build a server of type "([^"]*)"$/ do |serverType|
  # connect to cobbler and check the type exists
  @xml_description = @cblr_api.call("get_system",serverType).inspect
  puts @xml_description
end

Then /^I should be able to connect to the provisioning server$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should recieve an XML file$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should create the virtual machine$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^that I want to confirm the server has been provisioned$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should connect libvirt$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should check the status of the server$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the server should be "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^that I want to confirm the server is running$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should connect to libvirt$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^confirm the status is running$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should ping the server$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^then I should be able to connect via SSH$/ do
  pending # express the regexp above with the code you wish you had
end

