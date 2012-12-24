This repository contains DBus clients written using the DBus library from hackage (hackage.haskell.org/package/dbus).

I wrote these clients to learn DBus, so they probably have quirks, but they seem to work.

There are two pairs of clients, one pair is for one-to-one communication, and one pair is for one-to-many broadcasting.

* math_receiver.hs and math_sender.hs demonstrate basic RPC functionality, or one-to-one communication
* sigial_emitter.hs and signal_listener.hs demonstrate basic publish-subscribe functionality, or many-to-one in form of signals.
