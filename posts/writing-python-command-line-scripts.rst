.. title: Writing Python command line scripts
.. slug: writing-python-command-line-scripts
.. date: 2014/01/19 14:57:29
.. tags: python
.. link: 
.. description: 
.. type: text

.. image:: ../galleries/python-logo.png
   :class: left

Python is great for writing command line scripts. Before extending a three line Bash script I usually rethink and implement it in Python.
This post should summarize some conventions and best practices I recommend.

.. TEASER_END

Command Line Options
--------------------

Do you know the command line options of GNU tar? Probably not all of them. Does ``-v`` just show the version or does it enable verbose mode?
Defining some standard options avoids confusion and will let you focus on the more important aspects: writing the actual script logic.
I use the following standard options for my scripts:

-v, --verbose  Enable verbose/debug output/logging
-q, --quiet    Enable quiet/silent mode (only show warnings and errors)
--dry-run      No-op mode which should not modify anything

The Python ``argparse`` module is excellent for command line option parsing:

.. code:: python
    
    from argparse import ArgumentParser 
    parser = ArgumentParser()
    group = parser.add_mutually_exclusive_group()
    group.add_argument('-v', '--verbose', help='Verbose (debug) logging', action='store_const', const=logging.DEBUG,
                        dest='loglevel')
    group.add_argument('-q', '--quiet', help='Silent mode, only log warnings', action='store_const',
                        const=logging.WARN, dest='loglevel')
    parser.add_argument('--dry-run', help='No-op, do not write anything', action='store_true')
    args = parser.parse_args()

By using the ``add_mutually_exclusive_group``, the user is prevented from accidentally specifying both ``-v`` and ``-q`` (they would contradict each other).

There is something to watch out if you are defining command line options: Often you will need some sensitive data passed into your script,
e.g. user and password to connect to a database. As command line options are visible in shell history, in CRON logs, CRON mails and even remote via SNMP (!) **it should never be necessary to pass credentials via command line options**!
To avoid passing passwords on the command line you can either:

* require a config file for your script --- but a config file should only be used if the configuration is complex enough
* use some other authentication mechanism (e.g. Kerberos) --- this is often not possible
* use an existing credentials store (e.g. ``~/.pgpass`` for PostgreSQL when using psycopg2_) --- if you can, use this solution (esp. for psycopg2)
* allow passing passwords via special files

I'm often using the last approach by allowing to load a password from file if the option value starts with "@":

.. code:: bash

    ./my-script.py --host myhost --user hjacobs --password @~/.mysecretpw

Another pitfall comes when printing/logging options passed to the script. It should be a matter of course not printing complete database connection strings or similar sensitive information.


Logging
-------

Sprinkling your script with ``print`` statements is a bad idea.
By using the standard ``logging`` module we get log levels, string formatting and exception printing for free:

.. code:: python

   import logging, sys

   logging.basicConfig(level=logging.DEBUG)
   
   logging.debug('Starting the script %s..', sys.argv[0])
   try:
       logging.info('Doing something important')
       # .. do something ..
   except:
       logging.exception('Something went wrong')

I recommend the following guidelines for log levels:

DEBUG
  Information about the script's execution details normally not necessary to see.
  DEBUG lines will be printed/logged if ``--verbose`` (``-v``) command line argument is used.

INFO
  This should be the default expected output of your script. The script's main tasks should be appropriately reflected by INFO log lines.

WARN
  Warnings should be "fixable" by the user.
  WARN log entries would also be shown in CRON mails for CRON command line scripts, i.e. they should be fixed (for consistency) but have no real impact. WARN log entries should be printed even if the ``--quiet`` (``-q``) command line flag is used.

ERROR
  Every error state requiring the user's attention and potentially preventing the successful script termination.

Header and Structure
--------------------

By adding the right shebang we can make the script executable (still needs ``chmod +x`` of course). The encoding is important for string literals:

.. code:: python

    #!/usr/bin/env python
    # -*- coding: utf-8 -*-
    '''
    A docstring header can contain the script's main purpose
    and author information
    '''

By using a docstring instead of a regular comment we can easily reuse it in different places, e.g. we can pass it as a ``description`` parameter to the ``ArgumentParser`` class.

Split your main script logic from argument parsing and use the ``__name__`` check to allow importing your script:

.. code:: python

    def main(args):
        # main script logic

    if __name__ == '__main__':
        # ....
        args = parser.parse_args()
        main(args)

Now you can use the standard python repl or ipython_ to import and test your script:

.. code:: bash

    python
    >>> import myscript
    >>> myscript.some_func()



DOs and DON'Ts
--------------

* DO use the ``argparse`` module
* DO allow specifying all configurations via arguments (if they are not overly complicated)
* DO use the ``logging`` module and follow logging guidelines
* DO check your code with ``pyflakes``
* DO format your code according to PEP8_
* DO use meaningful return codes (``sys.exit(retcode)``)
* DON'T (never!) pass sensitive credentials (passwords) via command line options
* DON'T (never!) print information which could contain sensitive information (e.g. database connection strings)
* DON'T use ``print`` statements, use standard logging instead
* DON'T use old-style string formatting (``%`` operator), use built-in logging format strings or ``"{}".format(..)``.

For pyflakes and code formatting (PEP8-like) I use my codevalidator.py_ script.

Example Script
--------------

.. listing:: example-command-line-script.py python


.. _psycopg2: https://pypi.python.org/pypi/psycopg2
.. _ipython: http://ipython.org/
.. _PEP8: http://www.python.org/dev/peps/pep-0008/
.. _codevalidator.py: https://github.com/hjacobs/codevalidator
