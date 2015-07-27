API Access
==========

Topkit Developer and Topkit Server communicate via Topkit CLI and Topkit API.

Topkit uses a `key` and a `secret` to authenticate every request, even for
`GET` requests. To generate a new key pair, run the following command from the
server.

```text
$ topkit generate key [NAME]
```

This will generate a unique key/secret pair for access to your app. Permissions
are all the same, so you don't need to worry about that.

The `[NAME]` argument is a unique slug from which to reference the key pair.

You can get rid of a key at any point using the `remove` action.

```text
$ topkit remove key [NAME]
```

> With these commands, it's best if you give each of your team members a unique
> key/secret. That way you can get rid of just one pair if you need to remove
> that person's access.
