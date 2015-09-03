Creating A New User
==========

New users are created _locally, vis the CLI_. What we need to test here is how
Topkit Server responds to the request, _not_ how Topkit CLI handles the
response.

> An API `POST` to `[server_url]/api/v2/users.json` with data in this format:
>
>     data = {
>       :users => {
>         :name => '',
>         :email => '',
>         :password => '',
>         :password_confirmation => '',
>         :admin => true
>       }
>     }
>
> should return a hash of the user data and the status (`200`) if the data is
> valid. If the data is invalid, it will return a status of `500`, along with
> the error messages.

