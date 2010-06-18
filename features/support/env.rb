class Libvirt_helper

	def initialize(hash_string) 
		
	retstring = "<domain type='kvm'>  <name>#{hash_string['hostname']}</name>  <uuid></uuid>  <memory>#{hash_string['virt_ram']}</memory>  <vcpu>#{hash_string['virt_cpus']}</vcpu>  <os>    <type arch='i686'>hvm</type>  </os>  <clock sync='localtime'/>  <devices>    <emulator>/usr/bin/qemu-kvm</emulator>    <disk type='file' device='disk'>      <source file='/var/lib/libvirt/images/demo2.img'/>      <target dev='hda'/>    </disk>    <interface type='network'>      <source network='default'/>      <mac address='24:42:53:21:52:45'/>    </interface>    <graphics type='vnc' port='-1' keymap='de'/>  </devices></domain>"
	return retstring
end
end

