.. title: Synchronizing GnuCash mobile with GnuCash desktop
.. slug: synchronizing-gnucash-mobile-with-gnucash-desktop
.. date: 2014/01/18 20:59:48
.. tags: gnucash, python
.. link: 
.. description: 
.. type: text

Since 2002 I'm using GnuCash to track my personal accounts, incomes and expenses.
Just recently I discovered the `GnuCash mobile`_ Android app. After importing my GnuCash account tree into the mobile app I could easily add expense transactions.
The only problem was: How do I get the recorded transactions back into my GnuCash desktop application? The mobile app supports exporting transactions to QIF or OFX files.
These files can be imported by the desktop application. But I realizied this manual process is too cumbersome to use on a daily basis.

.. TEASER_END

Python to the rescue!
---------------------

I'm not sure why, but being a Python fan and using GnuCash since 2002 I still never discovered the GnuCash Python bindings --- until now!
The GnuCash Python bindings allow me to directly interact with the GnuCash backend. Synchronizing from the mobile app should be easy:

1. Export from GnuCash mobile to QIF file on the Android phone
2. Connect the Android phone via USB
3. Scan the Android phone for new QIF files via MTP
4. Parse QIF files and import transactions into my main account file (.gnucash).


.. _GnuCash mobile: https://play.google.com/store/apps/details?id=org.gnucash.android
