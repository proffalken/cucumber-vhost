#require the relevant libraries
require 'rubygems'
require 'libvirt'
require 'xmlrpc/client'
require 'net/ssh'

# setup the globals

#cobbler server:
@cobbler_server = "localhost"
@cobbler_port = "80"

#Libvirt
@libvirt_host = ""
@libvirt_type = "system"
@libvirt_storage_pool = "VBox"


## VM Connection
vmconn =  Libvirt::open("qemu://#{@libvirt_host}/#{@libvirt_type}")
### VM Storage
vm_stor = vmconn.lookup_storage_pool_by_name(@libvirt_storage_pool)   


## Cobbler API
cblr_api = XMLRPC::Client.new(@cobbler_server,"/cobbler_api",@cobbler_port)

Given /^that I want to build a server of type "([^"]*)"$/ do |serverType|
  puts "Building Continuous Integration Environment for #{serverType}"
  @serverType = serverType
end

Then /^I should be able to connect to the provisioning server$/ do
  # connect to cobbler and check the type exists
  @xml_description = cblr_api.call("get_system_for_koan",@serverType)
end

Then /^I should recieve an XML file$/ do
  virt_mem = @xml_description['virt_ram'].to_i
  virt_ram = virt_mem.to_i * 1024
  mac = @xml_description['interfaces']['eth0']['mac_address']
  virt_bridge = @xml_description['interfaces']['eth0']['virt_bridge']

  @sys_xmloutput = <<-eos
<domain type='kvm'>
  <name>#{@xml_description['hostname']}-ci-build</name>
  <uuid></uuid>
  <memory>#{virt_ram}</memory>
  <currentMemory>#{virt_ram}</currentMemory>
  <vcpu>#{@xml_description['virt_cpus']}</vcpu>
  <os>
    <type arch='#{@xml_description['arch']}' machine='pc-0.12'>hvm</type>
    <boot dev='hd' />
    <boot dev='network' />
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
      <source file='#{@xml_description['virt_path'] + "/" + @xml_description['hostname']}-ci-build.img'/>
      <target dev='hda' bus='ide'/>
    </disk>
    <interface type='bridge'>
      <mac address='#{mac}'/>
      <source bridge='#{virt_bridge}'/>
      <model type='rtl8139' />
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

@disk_xmloutput =<<-eos
      <volume>
        <name>#{@xml_description['hostname']}-ci-build.img</name>
        <allocation>0</allocation>
        <capacity unit="G">8</capacity>
        <target>
          <path>#{@xml_description['virt_path'] + "/" + @xml_description['hostname']}-ci-build.img</path>
        </target>
      </volume>
eos
end

Then /^I should create the virtual machine$/ do
  vm_stor.create_vol_xml(@disk_xmloutput)
  vmconn.define_domain_xml(@sys_xmloutput)
end

Given /^that I want to confirm the server has been provisioned$/ do
end

Then /^I should connect libvirt$/ do
end

Then /^I should check the status of the server$/ do
  #serverName = @xml_description['hostname']+"-ci-build"
  #ciDomain = vmconn.lookup_domain_by_name(serverNme)
end

Then /^the server should be "([^"]*)"$/ do |arg1|
  # puts ciDomain.info['state']
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

