# vim: ft=sls

{#-
    Installs tinty completions for all managed users.
    Has a dependency on `tool_tinty.package`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as tinty with context %}

include:
  - {{ sls_package_install }}


{%- for user in tinty.users | selectattr("completions", "defined") | selectattr("completions") %}

Completions directory for Tinty is available for user '{{ user.name }}':
  file.directory:
    - name: {{ user.home | path_join(user.completions) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true

Tinty shell completions are available for user '{{ user.name }}':
  cmd.run:
    - name: tinty generate-completion {{ user.shell }} > {{ user.home | path_join(user.completions, "_tinty") }}
    - creates: {{ user.home | path_join(user.completions, "_tinty") }}
    - onchanges:
      - Tinty is installed
    - runas: {{ user.name }}
    - require:
      - Tinty is installed
      - Completions directory for Tinty is available for user '{{ user.name }}'
{%- endfor %}
