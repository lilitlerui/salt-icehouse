/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://neutron/template/neutron.conf.template
    - user: neutron
    - group: neutron
    - mode: 644
    - template: jinja

set-vmnic-up:
  cmd.run:
    - name: /sbin/ifconfig {{ salt['pillar.get']('vm_nic') }} up 
    - user: root

openvswitch-add-br:
  cmd.run:
    - name: /usr/bin/ovs-vsctl add-br br-int
    - unless: ovs-vsctl list-br |grep br-int
    - user: root

openvswitch-add-port:
  cmd.run:
    - name: /usr/bin/ovs-vsctl add-port br-int {{ salt['pillar.get']('vm_nic') }}
    - unless: ovs-vsctl list-ports br-int |grep "^{{ salt['pillar.get']('vm_nic') }}"
    - user: root
    - require:
      - cmd: set-vmnic-up
      - cmd: openvswitch-add-br

/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini:
  file.managed:
    - source: salt://neutron/template/ovs_neutron_plugin.ini.template
    - user: neutron
    - group: neutron
    - mode: 644
    - makedir: True
    - template: jinja

/etc/neutron/plugin.ini:
  file.symlink:
    - target: /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
    - require:
      - file: /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini

change_neutron_owner:
  cmd.run:
    - name: /bin/chown -R neutron.neutron /etc/neutron/
    - user: root
    - require:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugin.ini

{% for log in ['server','openvwitch-agent','dhcp-agent','dhcp-helper'] %}
/var/log/neutron/{{log}}.log:
  file.managed:
    - user: neutron
    - group: neutron
    - mode: 644
{% endfor %}

{% for srv in ['neutron-server','neutron-openvswitch-agent','neutron-dhcp-agent'] %}
{{ srv }}:
  service.running:
    - enable: True
    - require:
      - file: /etc/neutron/neutron.conf
      - cmd: openvswitch-add-port
    - watch:
      - file: /etc/neutron/neutron.conf
{% endfor %}
