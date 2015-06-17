/etc/my.cnf:
  file.managed:
    - source: salt://mysql/template/my.cnf.template
    - user: mysql
    - group: mysql

mysqld:
  service.running:
    - watch:
      - file: /etc/my.cnf

/opt/script/mysql_init.sh:
  file.managed:
    - source: salt://mysql/template/mysql_init.sh.template
    - user: root
    - group: root 
    - mode: 755
    - makedirs: True
  cmd.run:
    - shell: /bin/bash
    - cwd: /opt/script 
    - user: root
