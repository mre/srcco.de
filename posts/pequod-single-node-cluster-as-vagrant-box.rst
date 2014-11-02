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



.. _Vagrant download site: https://www.vagrantup.com/downloads.html
.. _VirtualBox: https://www.virtualbox.org/
.. _Pequod cloud solution: http://pequod.zone/
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
