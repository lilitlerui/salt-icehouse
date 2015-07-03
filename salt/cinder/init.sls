/etc/cinder/cinder.conf:
  cmd.run:
    - name: /bin/mv /etc/cinder/cinder.conf /etc/cinder/cinder.conf.`date +%s`
    - user: root
  file.managed:
    - source: salt://cinder/template/cinder.conf.template
    - user: cinder
    - group: cinder
    - mode: 644
    - template: jinja

/etc/cinder/api-paste.ini:
  cmd.run:
    - name: /bin/mv /etc/cinder/api-paste.ini /etc/cinder/api-paste.ini.`date +%s`
    - user: root
  file.managed:
    - source: salt://cinder/template/api-paste.ini.template
    - user: cinder
    - group: cinder
    - mode: 644
    - template: jinja

/etc/cinder/volume.filters:
  file.managed:
    - source: salt://cinder/template/volume.filters.template
    - user: cinder
    - group: cinder
    - mode: 644
    - template: jinja

cinder-db-sync:
  cmd.run:
    - name: /usr/bin/cinder-manage db sync
    - user: cinder
    - require:
      - file: /etc/cinder/cinder.conf
      - file: /etc/cinder/api-paste.ini

openstack-cinder:
  service.running:
    - names: 
      - openstack-cinder-api
      - openstack-cinder-scheduler
{% if salt['pillar.get']('cinder_volume_type') != 'local' %}
      - openstack-cinder-volume
{% endif %}
{% if salt['pillar.get']('enable_backups') == 'true' %}
      - openstack-cinder-backup
{% endif %}
    - enable: True
    - watch:
      - file: /etc/cinder/cinder.conf
    - require:
      - cmd: cinder-db-sync
      - file: /etc/cinder/cinder.conf
      - file: /etc/cinder/api-paste.ini

