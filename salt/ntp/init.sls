/etc/ntp.conf:
  file.managed:
    - source: salt://ntp/template/ntp.conf.template
    - user: root
    - group: root

ntpd:
  service.running:
    - watch:
      - file: /etc/ntp.conf
    - enable: True
