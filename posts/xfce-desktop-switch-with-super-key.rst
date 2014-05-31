.. link: 
.. description: 
.. tags: xfce, xubuntu
.. date: 2014/05/29 17:44:44
.. title: XFCE desktop switch with Super key
.. slug: xfce-desktop-switch-with-super-key

.. image:: ../galleries/xfce-logo.png
   :class: left

After upgrading to Xubuntu_ 14.04 my beloved shortcut ``Super+1`` (left "Windows" key and "1" key) to switch to the first workspace/desktop did not work anymore.

.. TEASER_END

I really got used to these ``Super+N`` (where ``N`` = workspace number) shortcuts as they are easily doable with the left hand only (keys are close to each other) and the ``Super`` key is usually free to use for custom shortcuts.
I can configure ``Super+1`` in XFCE settings, but apparently the key combination does nothing --- or more precise: only the numeric key is recognized, i.e. when I press ``Super+1`` it will simply type "1" into the current window.

To make matters worse (or more mysterious) other key combinations using the ``Super`` modifier work. I configured ``Super+T`` to open the terminal emulator, ``Super+W`` for the web browser and ``Super+E`` for the file manager.
All these shortcuts work like a charm.

I tried xmodmap_, xev_ and looked into the XFCE configuration files --- without success.

Finally I found xdotool_ which allows sending arbitrary commands to X11 including switching the desktop::

    $ xdotool set_desktop 0 # will switch to first workspace

Surprisingly the ``Super+1`` combination works for application shortcuts, i.e. I simply configure `XFCE application shortcuts`_ for xdotool using ``xfce4-keyboard-settings``:

* Super+1: ``xdotool set_desktop 0`` 
* Super+2: ``xdotool set_desktop 1`` 
* Super+3: ``xdotool set_desktop 2`` 
* Super+4: ``xdotool set_desktop 3`` 

With this workaround I could get my handy desktop switching shortcuts back :-)

XFCE_ is a great simple desktop environment, but sometimes small issues make life harder than it should be.

.. _Xubuntu: http://xubuntu.org
.. _xmodmap: http://manpages.ubuntu.com/manpages/trusty/man1/xmodmap.1.html
.. _xev: http://manpages.ubuntu.com/manpages/trusty/man1/xev.1.html
.. _xdotool: http://www.semicomplete.com/projects/xdotool/
.. _XFCE application shortcuts: http://docs.xfce.org/xfce/xfce4-settings/keyboard#application_shortcuts
.. _XFCE: http://www.xfce.org/
