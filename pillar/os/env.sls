#-------------ip----------------
ip_mysql: 10.111.133.66
ip_rabbitmq: 10.111.133.66
ip_keystone: 10.111.133.66
ip_glance: 10.111.133.66
ip_nova: 10.111.133.66
ip_neutron: 10.111.133.66
ip_cinder: 10.111.133.66

#-----------rbd pool-------------
cinder_volume_type: rbd
cinder_rbd_name: volumes
enable_backups: false
glance_volume_type: rbd
glance_rbd_name: volumes
nova_rbd_type: rbd
nova_rbd_name: volumes

#------------vm network-----------
vm_nic: eth1
neutron_type: vlan

#------------authorized-----------
tenant_name: service 
tenant_user_nova: nova
tenant_user_neutron: neutron
tenant_user_cinder: cinder
tenant_user_glance: glance
tenant_pass_nova: service_pass
tenant_pass_glance: service_pass
tenant_pass_neutron_: service_pass
tenant_pass_cinder: service_pass
#----
mysql_keystoen_dbname: keystone
mysql_keystone_user: keystone
mysql_keystone_pass: keystone
#----
mysql_glance_dbname: glance
mysql_glance_user: glance
mysql_glance_pass: glance
#----
mysql_cinder_dbname: cinder
mysql_cinder_user: cinder
mysql_cinder_pass: cinder
#----
mysql_neutron_dbname: neutron
mysql_neutron_user: neutron
mysql_neutron_pass: neutron
#----
mysql_nova_dbname: nova
mysql_nova_user: nova
mysql_nova_pass: nova
#----
rabbitmq_user: guest
rabbitmq_pass: openstack
