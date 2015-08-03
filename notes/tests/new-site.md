Creating A New Site
==========

A site can be generated locally through Topkit CLI. At any rate, when the site
is first ready to be created on Topkit Server, a command is run locally via
Topkit CLI.

> An API `POST` to `[server_url]/api/v2/sites.json` with data in this format:
>
>     data = {
>       :site => { :git_url => '' }
>     }
>
> should return a hash of the user data and the status (`200`) if the data is
> valid. If the data is invalid, it will return a status of `500`, along with
> the error messages.
>
> Success should also create a new site with the data from the `.config` file
> in the project repo.

For this to work:

* There must be a git repo hosting the project's code.
* The project must have a `.config` file with the site title, slug, UID, and
  git URL.
* Topkit Server must have read access to the git repo.
* Topkit Server would have had to trust the git server. This will have to be
  done with a manual hit the first time.
