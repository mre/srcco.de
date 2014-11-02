.. link:
.. description:
.. tags: docker, pequod
.. date: 2014/11/02 16:30
.. title: Pequod Single Node Cluster as Vagrant Box
.. slug: pequod-single-node-cluster-as-vagrant-box

.. image:: ../galleries/pequod-logo.png
   :class: left

Installing and configuring a private Platform as a Service (PaaS) usually is not an easy task.
Testing our (unreleased) Docker-based `Pequod cloud solution`_ becomes easier with our new single-node-cluster Vagrant box.
I'll show you how to get a "complete" trial Pequod cluster up and running with Vagrant.

.. TEASER_END

To run the single-node trial cluster, Vagrant needs to be installed first. Download the latest version for your OS from the `Vagrant download site`_.
You also need a recent version of VirtualBox_ installed.

Starting the Pequod Single-Node Cluster
=======================================

Perform the common steps to boot up the Vagrant box:

.. code-block:: bash

    $ vagrant init zalando/pequod-vbox # first download takes time
    $ vagrant up
    $ vagrant ssh

Cassandra and the Pequod core services need some time to start. Check the cluster status with the Pequod CLI:

.. code-block:: bash

    $ pequod st # = "status", any command can be abbreviated

You can check the startup progress by watching the log files:

.. code-block:: bash

    $ tail /var/log/cassandra/system.log
    $ tail /var/log/upstart/pequod-core-*.log

The ``pequod status`` output should look like this if everything is started::

    Checking auth-service.. . OK
    Checking file-replicator.. . OK
    Checking core-manager.. . OK
    Checking application-registry.. . OK
    Checking cluster-controller.. . OK
    Checking lbupdater.. . no endpoints 1/1 FAILED

Now check whether the Cluster Agent was successfully started:

.. code-block:: bash

    $ pequod

Running the CLI without arguments prints the cluster state by default, which should look like this::

    Node Name   Status     MB   VMHz Procs Files  Node Start Agent Start Templ.  Reboot Maintenance
    pequod-vbox REGISTERED 1994 3190 32768 202744     5m ago      3m ago UNKNOWN     no          no

    Instance Name Node Name Repo Application Name Ver Zone Status MB VMHz Procs Files Ipv6 Started

The output tells us that one app node (the Vagrant box itself) was ``REGISTERED`` at the Cluster Controller
and that no application instances are running.
This is what we would expect as no application was deployed yet.

Application Deployment
======================

Let's deploy our first example application "greeting-backend".

To make this example easier, we just perform everything as ``root`` from now on:

.. code-block:: bash

    $ sudo su - # become root inside the Vagrant box


First we checkout the code and build the Docker image:

.. code-block:: bash

    $ service bind9 restart # workaround to make sure DNS works
    $ git clone https://github.com/zalando/pequod-app-examples.git
    $ cd pequod-app-examples/greeting-backend
    $ docker build -t [fd7a:1234::1]:2195/example/greeting-backend:1 .

The strange tag notation on the ``docker build`` line already contains Pequod's local registry address (IP ``fd7a:1234::1`` and port 2195).
We need to upload ("push") the Docker image to the local Pequod Application Registry:

.. code-block:: bash

    $ docker push [fd7a:1234::1]:2195/example/greeting-backend:1

The Pequod Application Registry will automatically read the contained application manifest (``pequod.xml``).
We can now check that the application is available in Pequod:

.. code-block:: bash

    $ pequod registry # lists all Pequod apps

The output should include our freshly pushed example app::

    Repo    Application Name Ver Command Has Manifest Last Update
    hjacobs greeting-backend 1   /run.py          yes      3h ago
    example greeting-backend 1   /run.py          yes     42s ago

I pushed another version of "greeting-backend" to the "hjacobs" repository before, that's why the ``registry`` command lists two entries.

Having the example application uploaded to our registry, we should now be able to start it:

.. code-block:: bash

    $ pequod controller start example/greeting-backend:1 vbox-test

If everything went well, the ``pequod`` cluster status should now look like this::

    Node Name   Status     MB   VMHz Procs Files  Node Start Agent Start Templ.  Reboot Maintenance
    pequod-vbox REGISTERED 1994 3190 32768 202744    36m ago     34m ago UNKNOWN     no          no

    Instance Name                Node Name   Repo    Application Name Ver Zone      Status  MB  VMHz Procs Files Ipv6                         Started
    example-greeting-backend10da pequod-vbox example greeting-backend 1   vbox-test RUNNING 128 1000    10  4096 fd7a:1234::aacc:a710:a00:20f  6s ago

We successfully started our first very simple example application!

Let's start some more, just for fun::

    Node Name   Status     MB   VMHz Procs Files  Node Start Agent Start Templ.  Reboot Maintenance
    pequod-vbox REGISTERED 1994 3190 32768 202744    38m ago     36m ago UNKNOWN     no          no

    Instance Name                Node Name   Repo    Application Name Ver Zone      Status  MB  VMHz Procs Files Ipv6                         Started
    example-greeting-backend10da pequod-vbox example greeting-backend 1   vbox-test RUNNING 128 1000    10  4096 fd7a:1234::aacc:a710:a00:20f  2m ago
    example-greeting-backend24ec pequod-vbox example greeting-backend 1   vbox-test RUNNING 128 1000    10  4096 fd7a:1234::aacc:963:a00:20f  16s ago
    example-greeting-backendd931 pequod-vbox example greeting-backend 1   vbox-test RUNNING 128 1000    10  4096 fd7a:1234::aacc:da88:a00:20f 15s ago

You will get an error trying to start more application instances than the app node can provide resources for (no overbooking).
In this example our Vagrant box provides 3190 "virtual MHz" CPU resources (calculated from ``/proc/cpuinfo``) and our example application requires 1000 VMHz
--- i.e. we can start at most three "greeting-backend" instances.

We can squeeze another instance into our Pequod cloud by reducing the required resource:

.. code-block:: bash

    $ pequod controller start example/greeting-backend:1 vbox-test --cpu-vmhz=100

Play around with the Pequod cluster and explore the CLI by using ``--help`` on commands and subcommands.

More information and links can be found on the `Pequod Website`_.

.. _Vagrant download site: https://www.vagrantup.com/downloads.html
.. _VirtualBox: https://www.virtualbox.org/
.. _Pequod cloud solution: http://pequod.zone/
.. _Pequod Website: http://pequod.zone/
.. _Zalando Technology: http://tech.zalando.com/
.. _Pequod Cluster Agent: https://pypi.python.org/pypi/pequod-agent
.. _Pequod Documentation: http://pequod.readthedocs.org/
