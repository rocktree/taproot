Deploying A Site
==========

While content is controlled from one location, the code is always read from the
local instance. So, for you local code to take effect within Topkit Server, you
need to tell Topkit Server you're ready for an update.

Do this by running the `deploy` action.

```text
$ topkit deploy site [NAME]
```

Of course, you'll need to be sure the code you want to deploy has been pushed
to your remote git repo.

Set Primary Domain
----------

You can set or change your primary domain at any point using the `set domain`
action:

```text
$ topkit set domain [NAME] [DOMAIN]
```

The `[NAME]` here is the _site name_, while the `[DOMAIN]` is the domain you'd
like to set.

Add/Remove Secondary Domains
----------

You can add or remove secondary domains at any point:

```text
$ topkit [add/remove] domain [NAME] [DOMAIN]
```

Topkit Server knows these domains are secondary domains, so there's no need to
distinguish. Just note that you can't remove a primary domain, you can only
replace it.
