/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://neutron/template/neutron.conf.template
    - user: neutron
    - group: neutron
    - mode: 644
    - template: jinja

openvswitch_service_init:
  cmd.run:
    - name: 
      - /usr/bin/ovs-vsctl add-br br-int
      - /usr/bin/ovs-vsctl add-br br-{{ salt['pillar.get']('vm_nic') }}
    - user: root

/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
  file.managed:
    - source: salt://neutron/template/ovs_neutron_plugin.ini.template
    - user: neutron
    - group: neutron
    - mode: 644
    - template: jinja

/etc/neutron/plugin.ini:
  file.symlink:
    - target: /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
    - require:
      - file: /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini

change_neutron_owner:
  cmd.run:
    - name: /bin/chown -R /etc/neutron/
    - user: root
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugin.ini

neutron-server:
  service.running:
    - name: 
      - neutron-server
      - neutron-openvswitch-agent
      - neutron-dhcp-agent
    - enable: True
    - require:
      - file: /etc/neutron/neutron.conf
      - cmd: openvswitch_service_init
    - watch:
      - file: /etc/neutron/neutron.conf
   
