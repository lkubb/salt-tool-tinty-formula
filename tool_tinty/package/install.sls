# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as tinty with context %}
{%- set version = tinty.get("version") or "latest" %}

{%- if tinty.install_method == "pkg" %}

Tinty is installed:
  pkg.installed:
    - name: {{ tinty.lookup.pkg.name }}
    - version: {{ version }}
    - require_in:
      - Tinty setup is completed

{%- elif tinty.install_method == "releases" %}
{%-   if version == "latest" %}
{%-     set version = salt["cmd.run_stdout"](
          "curl -ILs -o /dev/null -w %{url_effective} '" ~ tinty.lookup.pkg_src.latest ~
          "' | grep -o '[^/]*$' | sed 's/v//'",
          python_shell=true
        )
-%}
{%-   endif %}
{%-   set kernel_libc = tinty.lookup.kernel %}
{%-   if tinty.lookup.libc %}
{%-     set kernel_libc = kernel_libc ~ "-{}".format(tinty.lookup.libc) %}
{%-   endif %}

Tinty is installed:
  archive.extracted:
    - name: {{ tinty.lookup.paths.install_dir }}
    - source: {{ tinty.lookup.pkg_src.source.format(version=version, arch=tinty.lookup.arch, typ=tinty.lookup.typ, kernel_libc=kernel_libc) }}
    - source_hash: {{ tinty.lookup.pkg_src.source_hash.format(version=version, arch=tinty.lookup.arch, typ=tinty.lookup.typ, kernel_libc=kernel_libc) }}
    # The GitHub releases don't have a top directory
    - enforce_toplevel: false
    - overwrite: true
    - user: root
    - group: {{ tinty.lookup.rootgroup }}
    - file_mode: '0755'
    - unless:
      - >
          {{ tinty.lookup.paths.install_dir | path_join("tinty") | json }} --version | grep '{{ version }}'
  file.symlink:
    - name: {{ tinty.lookup.paths.bin_dir | path_join("tinty") }}
    - target: {{ tinty.lookup.paths.install_dir | path_join("tinty") }}
    - require:
      - archive: {{ tinty.lookup.paths.install_dir }}
    - require_in:
      - Tinty setup is completed

{%- else %}
{%-   do salt["test.exception"]("Unknown install_method: {}".format(tinty.install_method)) %}
{%- endif %}

Tinty setup is completed:
  test.nop:
    - name: Hooray, Tinty setup has finished.
