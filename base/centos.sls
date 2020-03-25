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
