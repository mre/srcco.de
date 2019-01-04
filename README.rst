========
srcco.de
========

.. code-block:: bash

    $ docker build -t hjacobs/srcco.de .
    $ docker run -u $(id -u) -v $(pwd):/workdir -t hjacobs/srcco.de nikola build
    $ xdg-open output/index.html



