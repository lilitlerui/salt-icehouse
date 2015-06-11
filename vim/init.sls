vim-enhanced:
  pkg:
    - installed

/tmp/vimrc:
  file.managed:
    - source: salt://vim/tmpalate/vimrc
    - require:
       - pkg: vim-enhanced
    - user: mail
    - group: mail
    - template: jinja

