rabbitmq-server:
  service:
    - name: rabbitmq-server
    - running

/opt/script/rabbitmq_init.sh:
  file.managed:
    - source: salt://rabbitmq/template/rabbitmq_init.sh.template
    - user: rabbitmq
    - group: rabbitmq 
    - mode: 755
  cmd.run:
    - shell: /bin/bash
    - cwd: /opt/script
    - user: root
