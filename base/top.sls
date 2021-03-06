{% set config = pillar.get('nginx',{})%}

{% if grains['os'] == 'Ubuntu' %}
logstash-ppa:
  pkgrepo.absent:
    - ppa: ondrej/php
php.packages:
  pkg.installed:
    - pkgs:
      - nginx
      - php7.3-fpm
      - php7.3-cli
      - php7.3-curl
copy config file:
  file.managed:
    - name: {{ config['config'] }}
    - source: salt://nginx/test.ubuntu.conf
    - require:
      - pkg: php.packages

{% elif grains['os']== 'CentOS' %}

packages:
  pkg.installed:
    - pkgs:
      - epel-release
      - yum-utils
remi:
  pkg.installed:
    - sources:
      - remi-release: http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    - requires:
      - pkg: packages
enable_optional_rpms:
  file.replace:
    - name: /etc/yum.repos.d/remi-php73.repo
    - pattern: '^enabled=[0,1]'
    - repl: 'enabled=1'
    - require:
      - pkg: remi
php.packages:
  pkg.installed:
    - pkgs:
      - nginx
      - php-fpm
      - php-cli
create forder www:
  file.directory:
    - user:  {{ config['user'] }}
    - name:  /var/www
    - group:  {{ config['user'] }}
    - mode:  755
copy config file:
  file.managed:
    - name: {{ config['config'] }}
    - source: salt://nginx/test.centos.conf
    - require:
      - pkg: php.packages
custom_php_config:
  file.managed:
    - name: /etc/php-fpm.d/www.conf
    - source: salt://php/www.conf
    - require:
      - pkg: php.packages
public:
  firewalld.present:
    - name: public
    - ports:
      - 80/tcp
      - 443/tcp
php-fpm_service:
  service.running:
    - name: php-fpm
    - enable: True
    - require:
      - pkg: php.packages

{% endif %}

create forder web:
  file.directory:
    - user:  {{ config['user'] }}
    - name:  {{ config['dir']}}
    - group:  {{ config['user'] }}
    - mode:  755
    - require: 
      - pkg: php.packages
create forder log:
  file.directory:
    - user: {{ config['user'] }}
    - name: {{ config['log'] }}
    - group: {{ config['user'] }}
    - mode:  755
    - require:
      - pkg: php.packages
nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: php.packages
copy file index:
  file.managed:
    - name: {{ config['dir'] }}/index.php
{% if grains['os'] == 'Ubuntu' %}
    - source: salt://ubuntu/index.php
{% elif grains['os']== 'CentOS' %}
    - source: salt://centos/index.php
{% endif %}

