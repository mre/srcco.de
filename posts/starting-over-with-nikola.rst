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

Starting a new Nikola site is fairly easy:

.. code:: bash

   nikola init myblog
   cd myblog
   nikola new_post # create a new post (will ask for title)
   nikola auto     # build and start internal webserver

Now I just needed to start my own theme:

.. code:: bash

   nikola install_theme base-jinja
   mkdir themes/mytheme
   echo 'base-jinja' > themes/mytheme/parent

I added a small custom filter in conf.py to "compress" whitespace in generated HTML:

.. code:: python

    from nikola import filters
    from functools import partial
    import re

    WHITESPACE_PATTERN = re.compile('\s+')
    PRE_BLOCKS = re.compile(r'<pre.*?pre>', re.DOTALL)

    def repl(m, captures):
        name = '$$CAPTURE-{}$$'.format(len(captures))
        captures[name] = m.group(0)
        return name

    def compress_whitespace(raw):
        '''
        >>> compress_whitespace('a  b')
        'a b'
        >>> compress_whitespace('a <pre> \\n </pre> b')
        'a <pre> \\n </pre> b'
        '''
        text = raw.decode('utf8')
        captures = {}
        text = PRE_BLOCKS.sub(partial(repl, captures=captures), text)
        text = WHITESPACE_PATTERN.sub(' ', text)
        for key, val in captures.items():
            text = text.replace(key, val)
        return text.encode('utf8')

    FILTERS = {
        ".css": [filters.yui_compressor],
        ".js": [filters.yui_compressor],
        ".jpg": [filters.jpegoptim],
        ".png": [filters.optipng],
        ".html": [filters.apply_to_file(compress_whitespace)]
    }

   

.. _Python Wiki blog software list: https://wiki.python.org/moin/PythonBlogSoftware
.. _me: http://www.jacobs1.de/
.. _Jinja2: http://jinja.pocoo.org/
.. _Python: http://www.python.org/
.. _Nikola: http://getnikola.com/
.. _documentation: http://getnikola.com/documentation.html
