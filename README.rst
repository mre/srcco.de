========
srcco.de
========

.. code-block:: bash

    $ docker build -t hjacobs/srcco.de .
    $ docker run -it -p 8000:8000 -u $(id -u) -v $(pwd):/workdir -t hjacobs/srcco.de nikola auto -a 0.0.0.0
