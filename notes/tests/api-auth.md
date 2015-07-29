API Authentication
==========

Key generation is tied to the user model.

> When a user is created, an API key is generated automatically and saved to
> the user model

The API is namespaced. The current version goes along with the application, so
it is all nested under `api/v2`.

> Any request to `api/...` that does not match an actual route should
> automatically return `401` response.

The user accessing the API needs to pass the key through the header in the request. This can be done like so:

```text
curl -H "X-Api-Key: abc123" http://0.0.0.0:3000/api/v2/authenticate.json -I
```

The `api/v2/authenticate.json` is simply a way to test whether the key is
authenticated or not. It does not do anything other than return `200` or `401`.

> The user accessing the API must pass a valid key in the header to be
> authenticated. A correct key should return `200`, while an incorrect key
> should return `401`.
