Authentication Tests
==========

**Prereqs**:

* User Account

**Permissions**:

* n/a (see below)

***

## Access Control

* An unauthenticated user should be able to get to the preview of any site
  within the application, so long as the site has working code (*which we
  shouldn't test here -- that will be for the viewer application [2.0])
* An unauthenticated user should not be able to access a single page within the
  builder. If attempting to do so, they should be directed to the sign in form.

## Signing In

* Signing in correctly should direct a user to the builder dashboard
  (builder/dashboard/index)

## Signing Out

* A user should be able to sign out on any page via the icon link in the
  header. (The only alternative to this is typing it is the address bar, which
  doesn't need to be tested)

## Devise

*All other scenarios are handled within (and tested by) Devise.*

## Permissions

*The difference in permissions is handled in a separate document.*
