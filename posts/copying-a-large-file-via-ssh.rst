.. title: Copying a large file via SSH
.. slug: copying-a-large-file-via-ssh
.. date: 2014/03/29 23:58:29
.. tags: 
.. link: 
.. description: 
.. type: text

.. image:: ../galleries/rsync-logo.png
   :class: left

SCP is great for copying files between hosts, but what if you want to up/download a large file through a
limited bandwidth connection without waiting for completion?

.. TEASER_END

Rsync_ comes to the rescue with it's "partial" transfer feature. You can simply start copying the file (also with SCP),
press CTRL+C to "pause" and restart the command:


.. code:: bash

   rsync --partial --progress largefile.zip myhost:largefile.zip
   

Of course, the same also works to resume a SSH copy if your transfer or computer crashed.

.. _Rsync: https://en.wikipedia.org/wiki/Rsync
