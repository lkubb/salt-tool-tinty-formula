# vim: ft=sls

{#-
    Removes the Tinty package.
    Has a dependency on `tool_tinty.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as tinty with context %}

include:
  - {{ sls_config_clean }}


{%- if tinty.install_method == "pkg" %}

Tinty is removed:
  pkg.removed:
    - name: {{ tinty.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}

{%- elif tinty.install_method == "releases" %}

Tinty is removed:
  file.absent:
    - names:
      - {{ tinty.lookup.paths.install_dir }}
      - {{ tinty.lookup.paths.bin_dir | path_join("tinty") }}
    - require:
      - sls: {{ sls_config_clean }}

{%- else %}
{%-   do salt["test.exception"]("Unknown install_method: {}".format(tinty.install_method)) %}
{%- endif %}
