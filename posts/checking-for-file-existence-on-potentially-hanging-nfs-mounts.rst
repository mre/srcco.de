.. title: Checking for file existence on potentially hanging NFS mounts
.. slug: checking-for-file-existence-on-potentially-hanging-nfs-mounts
.. date: 2014/01/31 21:23:51
.. tags: python
.. link: 
.. description: 
.. type: text

.. image:: ../galleries/python-logo.png
   :class: left

NFS mounts can be annoying as they tend to "hang" (for various reasons).
Here I show how I replaced `os.path.exists(..)` with a better solution for potentially hanging paths.

.. TEASER_END

The following code will "hang" if the NFS mount ``/mnt/nfs-shr`` is unresponsive:

.. code:: python

    if os.path.exists('/mnt/nfs-shr/file.txt'):
        print 'OK, file exists.' # .. do important stuff

I could not find any easy solution using the Python standard modules.
But what about using a small timeout? In my case I just want to print "OK" if the file exists and can be read.
Using the `subprocess32` module with timeouts and a reasonable command (`test`) works.

The `subprocess32`_ module is a backport of features found in `subprocess` of Python 3 to use on 2.x.
One of the best features of `subprocess32` is the `timeout` parameter for the `Popen` calls.

Installing the module as always:

.. code-block:: bash

    sudo pip install subprocess32

The resulting code looks like:

.. code-block:: python

    from subprocess32 import check_call
    try:
        check_call(['test', '-f', '/mnt/nfs-shr/file.txt'], timeout=0.5)
    except:
        pass # ignore non-zero return code and timeout exceptions
    else:
        print 'OK, file exists.' # .. do important stuff

This worked good enough for me.

.. _subprocess32: https://pypi.python.org/pypi/subprocess32/
