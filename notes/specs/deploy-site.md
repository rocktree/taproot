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

Working with Domains
----------

You can add or remove domains at any point:

```text
$ topkit [add/remove] domain [NAME] [DOMAIN]
```

The `[NAME]` here is the _site name_, while the `[DOMAIN]` is the domain with
which you'd like to work.

If you'd like to set the domain to redirect to another then you can use the `redirect-to` option:

```text
$ topkit add domain [NAME] [DOMAIN] --redirect-to=[DOMAIN]
```

If you've already added the domain and want to redirect it, you can use the
`set` action:

```text
$ topkit set domain [NAME] [DOMAIN] --redirect-to=[DOMAIN]
```
