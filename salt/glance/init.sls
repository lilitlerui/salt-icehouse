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

{% for srv in ['api','registry'] %}
/var/log/glance/{{srv}}.log:
  file.managed:
    - user: glance
    - group: glance
    - mode: 644
{% endfor %}

glance-db-sync:
  cmd.run:
    - name: /usr/bin/glance-manage db_sync
    - user: glance
    - require:
      - file: /etc/glance/glance-registry.conf
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-api-paste.ini
      - file: /etc/glance/glance-registry-paste.ini

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
