nginx:
  config: '/etc/nginx/conf.d/test.conf'
{% if grains['osrelease'] == '19.10' %}
  sourcecfg: 'salt://nginx/test73.conf'
{% else %}
  sourcecfg: 'salt://nginx/test72.conf'
{% endif % }
  user: 'root'
  dir: '/var/www/test.vn'
  log: '/var/log/nginx/test.vn'
