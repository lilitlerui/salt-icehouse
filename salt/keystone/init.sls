/etc/keystone/keystone.conf:
  cmd.run:
    - name: /bin/mv /etc/keystone/keystone.conf /etc/keystone/keytone.conf.`date +%s`
    - user: root
    
  file.managed:
    - source: salt://keystone/template/keystone.conf.template
    - user: keystone
    - group: keystone
    - mode: 640
    - template: jinja

/root/osenv:
  file.managed:
    - source: salt://keystone/template/osenv.template
    - user: keystone
    - group: keystone
    - mode: 750
    - template: jinja

keystone-db-sync:
  cmd.run:
    - name: /usr/bin/keystone-manage db_sync
    - user: keystone
    - require:
      - file: /etc/keystone/keystone.conf

openstack-keystone:
  service.running:
    - name: openstack-keystone
    - watch:
      - file: /etc/keystone/keystone.conf
    - require:
      - file: /etc/keystone/keystone.conf
      - cmd: keystone-db-sync

/etc/keystone/keystone_data.sh:
  file.managed:
    - source: salt://keystone/template/keystone_data.sh.template
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - cmd: keystone-db-sync
      - service: openstack-keystone
  cmd.run:
    - shell: /bin/bash
    - cwd: /etc/keystone
    - user: root
  

/etc/keystone/keystone_endpoint.sh:
  file.managed:
    - source: salt://keystone/template/keystone_endpoint.sh.template
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - cmd: /etc/keystone/keystone_data.sh
      - service: openstack-keystone
  cmd.run:
    - shell: /bin/bash
    - cwd: /etc/keystone
    - user: root
