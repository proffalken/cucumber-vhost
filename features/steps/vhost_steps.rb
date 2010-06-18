#require the relevant libraries
require 'rubygems'
require 'libvirt'
require 'xmlrpc/client'
require 'net/ssh'
require 'cobravsmongoose'

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
cblr_api = XMLRPC::Client.new(@cobbler_server,"/cobbler_api",@cobbler_port)

Given /^that I want to build a server of type "([^"]*)"$/ do |serverType|
  # connect to cobbler and check the type exists
  @xml_description = cblr_api.call("get_system_for_koan",serverType)

  virt_mem = @xml_description['virt_ram'] * 1024

  puts <<-eos
<domain type='kvm'>
  <name>#{@xml_description['hostname']}</name>
  <uuid></uuid>
  <memory>#{virt_mem}</memory>
  <currentMemory>#{virt_mem}</currentMemory>
  <vcpu>#{@xml_description['virt_cpus']}</vcpu>
  <os>
    <type arch='x86_64' machine='pc-0.12'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <pae/>
  </features>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>restart</on_crash>
  <devices>
    <emulator>/usr/bin/kvm</emulator>
    <disk type='file' device='disk'>
      <source file='/home/mwallace/.VirtualBox/kvm-images/icinga-disk0'/>
      <target dev='hda' bus='ide'/>
    </disk>
    <interface type='bridge'>
      <mac address='00:16:3e:5d:0f:6f'/>
      <source bridge='virbr0'/>
    </interface>
    <console type='pty'>
      <target port='0'/>
    </console>
    <console type='pty'>
      <target port='0'/>
    </console>
    <input type='mouse' bus='ps2'/>
    <graphics type='vnc' port='-1' autoport='yes' keymap='en-gb'/>
    <video>
      <model type='cirrus' vram='9216' heads='1'/>
    </video>
  </devices>
</domain>

eos
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

