.. title: Synchronizing GnuCash mobile with GnuCash desktop
.. slug: synchronizing-gnucash-mobile-with-gnucash-desktop
.. date: 2014/01/18 20:59:48
.. tags: gnucash, python
.. link: 
.. description: 
.. type: text

.. image:: ../galleries/GnuCash_logo.png
   :class: left

Since 2002 I'm using GnuCash_ to track my personal accounts, incomes and expenses.
Just recently I discovered the `GnuCash mobile`_ Android app. After importing my GnuCash account tree into the mobile app I could easily add expense transactions.
The only problem was: How do I get the recorded transactions back into my GnuCash desktop application? The mobile app supports exporting transactions to QIF_ or OFX files.
These files can be imported by the desktop application. But I realized that this manual process is too cumbersome to use on a daily basis.

.. TEASER_END

Python to the rescue!
---------------------

I'm not sure why, but being a Python fan and using GnuCash since 2002 I still never discovered the `GnuCash Python bindings`_ --- until now!
The GnuCash Python bindings allow me to directly interact with the GnuCash backend. Synchronizing from the mobile app should be easy:

1. Export from GnuCash mobile to QIF file on the Android phone
2. Connect the Android phone via USB
3. Scan the Android phone for new QIF files via MTP_
4. Parse QIF files and import transactions into my main account file (.gnucash).

You can find my Python script on Github_:

.. code:: bash

   sudo apt-get install gnucash python-gnucash mtp-tools
   git clone https://github.com/hjacobs/gnucash-qif-import
   cd gnucash-qif-import
   ./import.py -v -f ~/my-accounts.gnucash mtp:.*.qif

So now I can simply record my expenses using the Android app and connect the phone once a day via USB.
Before connecting the phone I still have to press "Export transactions..." in GnuCash mobile to save the QIF file on my phone's flash disk.
Maybe I will patch the mobile app to autosave QIF files periodically...


.. _GnuCash: http://www.gnucash.org/
.. _GnuCash mobile: https://play.google.com/store/apps/details?id=org.gnucash.android
.. _QIF: https://en.wikipedia.org/wiki/Quicken_Interchange_Format
.. _GnuCash Python bindings: http://wiki.gnucash.org/wiki/Python
.. _MTP: https://en.wikipedia.org/wiki/Media_Transfer_Protocol
.. _Github: https://github.com/hjacobs/gnucash-qif-import
