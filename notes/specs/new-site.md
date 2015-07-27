Creating A Site
==========

Both Topkit Developer and Topkit Server use Topkit CLI to facilitate the
process of going through the setup of a new site.

The site code will need to exist on a Topkit Server instance before it can be
used with Topkit Developer. However, since Topkit Server doesn't push any code,
it will need to be created using Topkit Developer.

01: Create Site Codebase
----------

The codebase can be generated with the default files using the following
command:

```text
$ topkit init site [NAME]
```

**The `[NAME]` is the glue that holds all references to the site together.
Whatever naming convention you use is fine, but know that changing it after
you've created it will be a challenging task.**

If you'd like to use a template other than the default, you can pass it a
template option and pass **a git repo url** as its value.

```text
$ topkit init site [NAME] --template=[URL]
```

02: Push to Remote Repo
----------

The creation of a site and the import into Topkit Server are two separate tasks
simply because Topkit wants to be sure you have successfully pushed the code to
an accessible remote repo. And if you haven't, we don't have to run through the
whole thing again.

So, the next step is up to you. Push your new site to a remote git repo, and
**make sure your Topkit Server instance can pull from this repo**.

03: Import to Server
----------

Next, you have to tell Topkit Server you have a new site, and this will affect
the database.

```text
$ topkit setup site [NAME]
```

This task will tell Topkit Server to do the following:

* Find or create the site object
* Import the git repo
* Symlink to the correct files
* Precompile the assets
* Restart the server

Once again, make sure that `[NAME]` parameter is matching what you've used so
far.

04: Update Topkit Developer
----------

As soon as you need to use this site in Topkit Developer, you'll want to update
your database instance.

```text
$ topkit update content
```

05: Share Code
----------

Your teammates probably need this code, too. Because the git repo is stored in
the database, importing a new site will update the content, then pull down the
code.

```text
$ topkit import site [NAME]
```

As usual, make sure that `[NAME]` stays consistent.
