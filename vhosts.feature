Feature: Testing Vhosts
	This feature is to be used to create and manage vhosts

	Scenario: Provision the server
		Given that I want to build a server of type "test"
		Then I should be able to connect to the provisioning server
		And I should recieve an XML file
		And I should create the virtual machine

	Scenario: Check the server has been built
		Given that I want to confirm the server has been provisioned
		Then I should connect libvirt
		And I should check the status of the server
		And the server should be "running"

	Scenario: Check the server has powered on correctly
		Given that I want to confirm the server is running
		Then I should connect to libvirt
		And confirm the status is running
		Then I should ping the server 
		And then I should be able to connect via SSH
