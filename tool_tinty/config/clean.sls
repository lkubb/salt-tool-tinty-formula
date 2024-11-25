# vim: ft=sls

{#-
    Removes the configuration of the Tinty package.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as tinty with context %}


{%- for user in tinty.users | selectattr("tinty.config", "defined") | selectattr("tinty.config") %}

Tinty config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_tinty"].conffile }}

Tinty config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user["_tinty"].confdir }}
{%- endfor %}
