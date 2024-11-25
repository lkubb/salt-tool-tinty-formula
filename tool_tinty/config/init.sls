# vim: ft=sls

{#-
    Manages the Tinty package configuration by

    * recursively syncing from a dotfiles repo
    * managing/serializing the config file afterwards

    Has a dependency on `tool_tinty.package`_.
#}

include:
  - .sync
  - .file
