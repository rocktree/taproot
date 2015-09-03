Installing Topkit
==========

To get your server prepared, you can use a specific version of
[Ripen](https://github.com/seancdavis/ripen), built for Topkit:

```text
$ bash <(curl -s https://raw.githubusercontent.com/topicdesign/topkit-cli/v1.0/bin/ripen)
```

Installing Topkit will be fairly straightforward when we have the `topkit` gem.
So, install that first:

```text
$ gem install topkit
```

**You need to have a Topkit Server instance before you install any Topkit
Developer instances**. You can do this quite easily from the command line of
the server.

```text
$ topkit init server
```

The install CLI will ask you a handful of questions to get up and running.

Once you have a Topkit Server instance, you can install as many Topkit
Developer Instances as you'd like. Just make sure you're teammates know the API
keys and other relevant data.

```text
$ topkit init developer
```
