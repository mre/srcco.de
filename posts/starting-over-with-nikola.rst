.. title: Starting over with Nikola
.. slug: starting-over-with-nikola
.. date: 2014/01/12 22:48:52
.. tags: nikola
.. link: 
.. description: 
.. type: text

This site was down for quite some time. I did not want to deploy the old PHP-based site again and therefore looked for alternatives.
I never used a static site generator before, but as this site has only a single author (me_), I decided to go for it.
Python_ is my favorite programming language, so the site generation tool should also be Python based. 
I started to look at the `Python Wiki blog software list`_ and quickly narrowed my choice down to Nikola_:

* Nikola looks more lightweight than Django based Hyde 
* Nikola supports Jinja2_ templates which I'm happily using in various projects.
* Nikola has its own site with documentation_ --- it's not perfect, but somebody cared enough to write it :-)

I'm using Nikola's developer version directly from github:

.. code:: bash

   git clone git://github.com/getnikola/nikola.git
   cd nikola
   sudo ./setup.py install

.. _Python Wiki blog software list: https://wiki.python.org/moin/PythonBlogSoftware
.. _me: http://www.jacobs1.de/
.. _Jinja2: http://jinja.pocoo.org/
.. _Python: http://www.python.org/
.. _Nikola: http://getnikola.com/
.. _documentation: http://getnikola.com/documentation.html
