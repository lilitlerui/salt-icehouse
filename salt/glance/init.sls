/etc/glance/glance-api.conf:
  cmd.run:
    - name: /bin/mv /etc/glance/glance-api.conf /etc/glance/glance-api.conf.`date +%s`
    - user: root
  file.managed:
    - source: salt://glance/template/glance-api.conf.template
    - user: glance
    - group: glance
    - mode: 640
    - template: jinja

/etc/glance/glance-api-paste.ini:
  file.managed:
    - source: salt://glance/template/glance-api-paste.ini.template
    - user: glance
    - group: glance
    - mode: 640
    - template: jinja

/etc/glance/glance-registry.conf:
  cmd.run:
    - name: /bin/mv /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf.`date +%s`
    - user: root
  file.managed:
    - source: salt://glance/template/glance-registry.conf.template
    - user: glance
    - group: glance
    - mode: 640
    - template: jinja

/etc/glance/glance-registry-paste.ini:
  file.managed:
    - source: salt://glance/template/glance-registry-paste.ini.template
    - user: glance
    - group: glance
    - mode: 640
    - template: jinja

change_glance_owner:
  cmd.run:
    - name: /bin/chown -R glance.glance /etc/glance/
    - require:
      - file: /etc/glance/glance-registry.conf
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-api-paste.ini
      - file: /etc/glance/glance-registry-paste.ini

glance-db-sync:
  cmd.run:
    - name: /usr/bin/glance-manage db_sync
    - user: glance
    - require:
      - file: /etc/glance/glance-registry.conf
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-api-paste.ini
      - file: /etc/glance/glance-registry-paste.ini

change_glance_log_owner:
  cmd.run:
    - name: /bin/chown -R glance.glance /var/log/glance/
    - require:
      - cmd: glance-db-sync

openstack-glance:
  service.running:
    - names:
      - openstack-glance-api
      - openstack-glance-registry
    - watch:
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-registry.conf
    - require:
      - cmd: glance-db-sync
      - cmd: change_glance_log_owner

