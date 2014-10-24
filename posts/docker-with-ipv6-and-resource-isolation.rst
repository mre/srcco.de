.. link:
.. description:
.. tags: docker, pequod
.. date: 2014/10/24 21:30:18
.. title: Docker with IPv6 and Resource Isolation
.. slug: docker-with-ipv6-and-resource-isolation

.. image:: ../galleries/docker-logo.png
   :class: left

To experiment with Docker and IPv6 in "production", I decided to migrate this tiny blog to our (unreleased) Docker-based Pequod Cloud Solution.
I will briefly describe how the setup looks like.

.. TEASER_END

As of today this blog runs in its own small Docker container which regularly rebuilds static HTML from `github source`_
and serves it with CherryPy_.

What did I do?
--------------

We are currently building our own Docker-based Pequod Cloud Solution at `Zalando Technology`_ and thus I decided to use the same technology to drive
my own tiny blog (even if it looks over-the-top for this use case).

First I had to upgrade my root server to Ubuntu 14.04 to get an appropriate Kernel to run Docker.

Next I installed the required packages to run the `Pequod Cluster Agent`_, these are:

* Docker 1.3 (following the Ubuntu installation steps)
* HAProxy 1.5
* bridge-utils (``apt-get install bridge-utils``)
* Tayga for NAT64 (``apt-get install tayga``)
* Bind9 (was already running)

Obviously I have to install the `Pequod Cluster Agent`_ itself, too:

.. code-block:: bash

    $ sudo pip3 install pequod-agent

In order to get my application running, I had to:

* Write the code (just `one bash script`_ and `twenty lines of Python`_)
* Create `the Dockerfile`_
* Define `the Pequod application manifest`_

Every application must have an application manifest (``pequod.xml``) in order to run on Pequod,
The manifest defines resource limits, filesystem mounts and services the application provides/requires.

The application is a very simple bash script which starts a CherryPy_ server to serve static HTML
and at the same time loops endlessly over ``git pull`` and ``nikola build`` (Nikola_ is the static blog generator I'm using).

As the ``git pull`` requires access to github.com, I also defined a helper `bootstrap YAML file`_ to define
github as an external service (usually this would be done in a specific Pequod cluster component,
but I'm using ``pequod-agent`` in "standalone mode")

Building the necessary Docker image is easy:

.. code-block:: bash

    $ docker build -t srcco-de:1 .

I created a small upstart init file to start the application with the Pequod Cluster Agent:

.. code-block:: bash

    $ cat /etc/init/pequod-agent.conf

    respawn
    exec pequod-agent --bootstrap srcco-de:1 /root/srcco.de/pequod-bootstrap.yaml

After starting (``service pequod-agent start``), the Docker container will automatically get connected to github.
The agent's ``--inspect`` shows this:

.. code-block:: bash

    $ pequod-agent -i services
    Instance Name              Repo Application Name Ver Type    Service      Ver Local Hostname                       Local Port
    bootstrap--srcco-de-1-9641      srcco-de         1   provide srcco-de     1   2a01:4f8:190:314e:aacc:6f04:509:944e       8000
    bootstrap--srcco-de-1-9641      srcco-de         1   require github-https 1   github.com                                  443

We can peek into the container using ``nsenter``:

.. code-block:: bash

    $ pequod-agent -i
    Instance Name              Repo Application Name Ver Zone      PID   IPv6                                 Started
    bootstrap--srcco-de-1-9641      srcco-de         1   bootstrap 14695 2a01:4f8:190:314e:aacc:6f04:509:944e 57m ago

    $ nsenter --net -t 14695 /bin/ip a show scope global
    40: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 76:82:4b:8b:b1:a4 brd ff:ff:ff:ff:ff:ff
        inet6 2a01:4f8:190:314e:ff11:c3b3:509:944e/64 scope global
           valid_lft forever preferred_lft forever
        inet6 2a01:4f8:190:314e:aacc:6f04:509:944e/64 scope global
           valid_lft forever preferred_lft forever

As you can see from the ``ip a`` output, the Docker container has IPv6 connectivity only.
If you have IPv6 connectivity on your local machine, you can `access the Docker container directly`_.

Summary
-------

This little experiment worked out so far (it seems, at least you can apparently read this page ;-)).
The setup is quite complex compared to my former setup with simple static HTML served by Apache.

What did I get in the end?

* This site is now automatically updated whenever I push to github.
* I proved that it's feasible to run the Pequod Cluster Agent in a small "standalone" environment.
* Packaging this site with Docker makes it easy to run it elsewhere.
* The Pequod agent gives me better resource isolation than the default ``docker run``.
* I finally configured my public /64 IPv6 subnet :-)

What are the downsides?

* Using CherryPy was only a "quick-and-dirty" choice to serve static HTML, the performance is by far not optimal.
* Running the Pequod Cluster Agent without the Pequod core components provides reduced availability.
  E.g. the Service Scheduler would restart instances in a regular Pequod cluster as soon as they die.
* The setup is overly complex for this tiny static blog site.


You can find all source code of this site in `my github repository`_.

You can find some more information about Pequod in the `Pequod Documentation`_.


.. _github source: https://github.com/hjacobs/srcco.de
.. _CherryPy: http://cherrypy.org/
.. _Zalando Technology: http://tech.zalando.com/
.. _Pequod Cluster Agent: https://pypi.python.org/pypi/pequod-agent
.. _one bash script: https://github.com/hjacobs/srcco.de/blob/master/run.sh
.. _twenty lines of Python: https://github.com/hjacobs/srcco.de/blob/master/serve.py
.. _the Dockerfile: https://github.com/hjacobs/srcco.de/blob/master/Dockerfile
.. _the Pequod application manifest: https://github.com/hjacobs/srcco.de/blob/master/pequod.xml
.. _Nikola: http://getnikola.com/
.. _bootstrap YAML file: https://github.com/hjacobs/srcco.de/blob/master/pequod-bootstrap.yaml
.. _access the Docker container directly: http://[2a01:4f8:190:314e:aacc:6f04:509:944e]:8000/
.. _my github repository: https://github.com/hjacobs/srcco.de
.. _Pequod Documentation: http://pequod.readthedocs.org/
