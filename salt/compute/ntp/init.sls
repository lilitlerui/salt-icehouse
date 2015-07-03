/etc/ntp.conf:
  file.managed:
    - source: salt://compute/ntp/template/ntp.conf.template
    - user: root
    - group: root
    - mode: 644

ntpd:
  service.running:
    - watch:
      - file: /etc/ntp.conf
    - enable: True
