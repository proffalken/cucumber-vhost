Feature: Testing Vhosts
	This feature is to be used to create and manage vhosts

	Scenario: Provision the server
		Given that I want to build a server of type "test"
		Then I should be able to connect to the provisioning server
		And I should recieve an XML file
		And I should create the virtual machine

	Scenario: Check the server has been built
		Given that I want to confirm the server "test" has been provisioned
		Then I should check the status of the server
		And the server should have a status of "running"

	Scenario: Check the server has powered on correctly
		Given that I want to confirm the server "test" has been provisioned
		Then I should check the status of the server
		And the server should have a status of "running"
		Then I should ping the server 
		And I should be able to connect the server on port "80"
	
	Scenario: Destroy the server
		Given that I want to destroy the server "test"
		Then I should be able to connect to the provisioning server
		Then I should check the status of the server
		And I should destroy the server
		And I should destroy the associated storage
		And I should undefine the server
		
