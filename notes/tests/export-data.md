Exporting Data
==========

Topkit Developer works independently of Topkit Server, but it needs a database
to function. Using Topkit CLI, developers can pull the data down to their local
Topkit Developer instance.

> An API `POST` to `[server_url]/api/v2/data/export.json` with an authenticated
> API key will run `rake db:data:dump`, and then return the `YAML` dump as
> text.
