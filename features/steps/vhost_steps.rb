# This file licensed under the GPL v 2.0 and above where appropriate

# define the type of server that we want to build
Given /^that I want to build a server of type "([^"]*)"$/ do |serverType|
  # echo the type of server to be built for debugging purposes
  puts "Building Continuous Integration Environment for #{serverType}"
  # set a global to be used in the rest of the process
  @serverType = serverType
end


# connect to cobbler and request the details for the host
Then /^I should be able to connect to the provisioning server$/ do
  # connect to cobbler and check the type exists, if it does, setup a list with all the details to be converted to xml
  @xml_description = @cblr_api.call("get_system_for_koan",@serverType)
end


# create the XML file to be used by LibVirt to import and create/edit/delete the VM
Then /^I should recieve an XML file$/ do
  # set some variables to be used in the file
  virt_mem = @xml_description['virt_ram'].to_i  # the memory that is allocated in cobbler (KB)
  virt_ram = virt_mem.to_i * 1024 # the memory to be used (MB)
  mac = @xml_description['interfaces']['eth0']['mac_address']  # The mac address to be assigned - Cobbler won't build without this!
  virt_bridge = @xml_description['interfaces']['eth0']['virt_bridge']  # The bridge interface on the physical host to used as defined in cobbler - loads of stuff breaks if this isn't set properly!


  # Generate the XML output as defined by LibVirt at http://www.libvirt.org/format.html

  # The system definition
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
      <model type='virtio' />
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


# The storage volume definition
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


# By this point, the script should have generated all the XML required to build th machine, so let's get on with it! :)
Then /^I should create the virtual machine$/ do

  # Create the storage first - if we don't, we can't create the VM
  @vm_stor.create_vol_xml(@disk_xmloutput)
  

  # This all gets a bit weird here, we need to define the domain, then query libvirt for the domain we just created, then start it otherwise it all falls over...
  # Now define the VM
  @vmconn.define_domain_xml(@sys_xmloutput)
  # query libvirt for the domain we just created
  domain = @vmconn.lookup_domain_by_name(@xml_description['hostname']+"-ci-build")
  # and create and start the VM
  domain.create()
end

# sometimes we just need to know that the VM has been created...

# which server type are we looking at here?
Given /^that I want to confirm the server "([^"]*)" has been provisioned$/ do |serverType|
	# set the global to the value passed
	@serverType = serverType
end

# find out what we should be checking for
Then /^I should check the status of the server$/ do
  # retrieve the serverType info from cobbler
  @xml_description = @cblr_api.call("get_system_for_koan",@serverType)
  # get the hostname
  serverName = @xml_description['hostname']
  # Connect to libvirt and create a domain object based upon the "ci-build" hostname
  @ciDomain = @vmconn.lookup_domain_by_name(serverName.to_s  + "-ci-build")
end

# So we know the VM exists - is it running or stopped?
Then /^the server should have a status of "([^"]*)"$/ do |requestedStatus|
  # get the current status of the domain
  curState = @ciDomain.info.state
  
  # Unfortunately the status is only ever returned as an int - any one who wants to find a prettier way of achieving the following is more than welcome to try!

  # The requested status is passed as a str, we need to convert it into an int so we can compare it with the current value returned
  case requestedStatus
	when "running" then reqState = 1
	when "stopped" then reqState = 5
  end

  # The current state is returned as an int so we need to convert it into a str so we can generate useful error messages
  case curState
	when 1 then actualStatus = "running"
	when 5 then actualStatus = "stopped"
	else actualStatus = "Unknown"
  end

  # check to see if the int values match - if they don't, error and print the string values... Simples!
  raise ArgumentError, "The VM was requested to be #{requestedStatus} however it was found to be #{actualStatus}" unless reqState == curState
  
end


# I really need to get around to writing these tests!
Then /^I should ping the server$/ do
	# ping the value of the IP Address retrieved from the xml_description
	while Ping.pingecho(@xml_description['interfaces']['eth0']['ip_address']) == false do
		sleep(20)
	end
		
end

Then /^then I should be able to connect via SSH$/ do
  pending # express the regexp above with the code you wish you had
end


# All the tests that we wanted to run are now complete, let's throw away the server so we know that we are always starting from a clean system next time.

# Which server do we want to destroy?
Given /^that I want to destroy the server "([^\"]*)"$/ do |serverType|
	# set the server type as before
	@serverType = serverType
end


# Destroy (which confusingly doesn't delete!) the server
Then /^I should destroy the server$/ do
	# we still have the domain set from earlier in the process, so stop it from running and destroy it
	@ciDomain.destroy()
end

# Remove the storage
Then /^I should destroy the associated storage$/ do
	# get the path to the storage as defined by cobbler
	path = @xml_description['virt_path'] + "/" + @xml_description['hostname'] + "-ci-build.img"
	# echo a debug message
	puts "Trying to delete #{path}"
	# get the volume details and assign it to an object	
	volume = @vm_stor.lookup_volume_by_path("#{@xml_description['virt_path'] + "/" + @xml_description['hostname']}-ci-build.img")
	# delete the object (unlike pools and domains, you don't have to undefine volumes as far as I can tell - I tried and it wouldn't let me!)
	volume.delete()	
end


# we're done here, let's throw away the VM
Then /^I should undefine the server$/ do
	# Use the existing domain pointer and undefine it, we're finished and all traces have disappeared from our systems!
	@ciDomain.undefine()
	
end

