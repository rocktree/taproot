Creating A Site
==========

**Prereqs**:

* User Account

**Permissions**:

* Authenticated User
* Admin User

***

## Required Fields

We need a `title`, `template_url` and `git_url` to do what we need to do.

## Creating A Site

With all the required fields in place, this is what should happen:

1. Import (pull) template
2. Change origin URL
4. Swap out [site], [_site], and [Site] with appropriate values.
5. Commit
6. Push
7. Create home template
8. Create home page
9. redirect to the new site's pages

This could be broken into multiple tests if necessary.

*Note: the first several actions here take place within the `SapwoodProject`
service object. I would imagine the testing could stay scoped to specific use
cases, but we may want to get lower level with feedback from the service
object. For example, how do we know and what do we do if git command line
actions fail?*
