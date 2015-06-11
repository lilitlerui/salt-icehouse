/etc/keystone/keystone.conf:
  file.managed:
    - source: salt://keystone/template/keystone.conf.template
    - user: keystone
    - group: keysone
    - mode: 640

openstack-keystone:
  service.running:
    - name: openstack-keystone
    - watch:
      - file: /etc/keystone/keystone.conf

keystone-db-sync:
  cmd.run:
    - name: /usr/bin/keystone-manage db_sync

/etc/keysytone/keystone_data.sh:
  file.managed:
    - source: salt://keystone/template/keystone_data.sh.template
    - user: keystone
    - group: keysone
    - mode: 755
  cmd.run:
    - shell: /bin/bash 
    - cwd: /etc/keystone
    - user: root

/etc/keysytone/keystone_endpoint.sh:
  file.managed:
    - source: salt://keystone/template/keystone_endpoint.sh.template
    - user: keystone
    - group: keysone
    - mode: 755
  cmd.run:
    - shell: /bin/bash
    - cwd: /etc/keystone
    - user: root
