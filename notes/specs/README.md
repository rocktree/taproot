Topkit Specifications
==========

The files within this directory outline the functional specs for Topkit, and
are modularized based on the type of content and/or action on which they focus.

Definitions
----------

* _Topkit Server_: This project, which will be hosted on the server. It will
  contain the builder (CMS) and the viewer (live site).
* _Topkit Developer_: A rails project to be used in development, which focuses
  on speeding up the development process.
* _Topkit CLI_: The ruby gem holding the command line tasks for both Topkit
  Developer and Topkit Server, but that are run primarily from Topkit
  Developer.
