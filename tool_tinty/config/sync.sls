# vim: ft=sls

{#-
    Syncs the Tinty package configuration
    with a dotfiles repo.
    Has a dependency on `tool_tinty.package`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as tinty with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch %}


{%- for user in tinty.users | selectattr("dotconfig", "defined") | selectattr("dotconfig") %}
{%-   set dotconfig = user.dotconfig if user.dotconfig is mapping else {} %}

Tinty configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user["_tinty"].confdir }}
    - source: {{ files_switch(
                    ["tinted-theming/tinty"],
                    lookup="Tinty configuration is synced for user '{}'".format(user.name),
                    config=tinty,
                    path_prefix="dotconfig",
                    files_dir="",
                    custom_data={"users": [user.name]},
                 )
              }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
{%-   if dotconfig.get("file_mode") %}
    - file_mode: '{{ dotconfig.file_mode }}'
{%-   endif %}
    - dir_mode: '{{ dotconfig.get("dir_mode", "0700") }}'
    - clean: {{ dotconfig.get("clean", false) | to_bool }}
    - makedirs: true
  cmd.run:
    - name: tinty sync
    - runas: {{ user.name }}
    - onchanges:
      - file: {{ user["_tinty"].confdir }}
{%- endfor %}
