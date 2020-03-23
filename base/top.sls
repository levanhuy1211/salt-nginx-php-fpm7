{% set config = pillar.get('nginx',{})%}

{% if grains['osrelease'] == '19.10' %}
php.packages:
  pkg.installed:
    - pkgs:
      - nginx
      - php7.3-fpm
      - php7.3-cli
      - php7.3-curl
{% else %}
php.packages:
  pkg.installed:
    - pkgs:
      - nginx
      - php7.2-fpm
      - php7.2-cli
      - php7.2-curl
{% endif %}
copy config file:
  file.managed:
    - name: {{ config['config'] }}
    - source: {{ config['sourcecfg'] }}
create forder web:
  file.directory:
    - user:  {{ config['user'] }}
    - name:  {{ config['dir']}}
    - group:  {{ config['user'] }}
    - mode:  755
create forder log:
  file.directory:
    - user: {{ config['user'] }}
    - name: {{ config['log'] }}
    - group: {{ config['user'] }}
    - mode:  755
copy file index:
  file.managed:
    - name: {{ config['dir'] }}/index.php
{% if grains['os'] == 'Ubuntu' %}
    - source: salt://ubuntu/index.php
{% elif grains['os']== 'Centos' %}
    - source: salt://centos/index.php
{% endif %}

