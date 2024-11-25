# vim: ft=sls

{#-
    Removes tinty completions for all managed users.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as tinty with context %}


{%- for user in tinty.users | selectattr("completions", "defined") | selectattr("completions") %}

Tinty shell completions are absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user.home | path_join(user.completions, "_tinty") }}
{%- endfor %}
