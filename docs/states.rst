Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_tinty``
~~~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_tinty.package``
~~~~~~~~~~~~~~~~~~~~~~
Installs the Tinty package only.


``tool_tinty.config``
~~~~~~~~~~~~~~~~~~~~~
Manages the Tinty package configuration by

* recursively syncing from a dotfiles repo
* managing/serializing the config file afterwards

Has a dependency on `tool_tinty.package`_.


``tool_tinty.config.file``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Manages the Tinty package configuration.
Has a dependency on `tool_tinty.package`_.


``tool_tinty.config.sync``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Syncs the Tinty package configuration
with a dotfiles repo.
Has a dependency on `tool_tinty.package`_.


``tool_tinty.completions``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Installs tinty completions for all managed users.
Has a dependency on `tool_tinty.package`_.


``tool_tinty.clean``
~~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_tinty`` meta-state
in reverse order.


``tool_tinty.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the Tinty package.
Has a dependency on `tool_tinty.config.clean`_.


``tool_tinty.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the Tinty package.


``tool_tinty.completions.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes tinty completions for all managed users.


