# vim: ft=sls

{#-
    Manages the Tinty package configuration.
    Has a dependency on `tool_tinty.package`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as tinty with context %}

include:
  - {{ sls_package_install }}


{%- for user in tinty.users | selectattr("tinty.config", "defined") | selectattr("tinty.config") %}

Tinty config file is managed for user '{{ user.name }}':
  file.serialize:
    - name: {{ user["_tinty"].conffile }}
    - mode: '0600'
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: true
    - dir_mode: '0700'
    - serializer: toml
    - dataset: {{ user.tinty.config | json }}
    - require:
      - sls: {{ sls_package_install }}
{%- endfor %}
