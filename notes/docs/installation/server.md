Topkit Server Installation
==========

Installation of the Topkit Server application has been streamlined by making
the requirements a little more strict. But it makes what you have to do nice
and easy.

You'll need these things:

* A [virtual private
  server](https://en.wikipedia.org/wiki/Virtual_private_server) with root
  access via ssh, running Ubuntu 14.04. We use [Digital
  Ocean](https://www.digitalocean.com/).
* A [Dropbox](https://www.dropbox.com/) account, which we'll use for file
  storage.
* A [SendGrid](https://sendgrid.com/) account, which we'll use for sending
  emails.

Prepare Server
----------

Log in to your server as the `root` user via SSH. Ideally, this is an otherwise
empty server.

We're using a specific configured version of
[Ripen](https://github.com/seancdavis/ripen) to install all the stuff you need.
You can get the process going with one command. You can run this command from
anywhere on the machine.

```text
$ bash <(curl -s https://raw.githubusercontent.com/topicdesign/topkit-cli/v1.0/bin/ripen)
```

Among many other tasks, this script creates a `topkit` user. Just before
completion, it asks you to choose a password. This is the user for whom you are
setting a password.

> If you want to know what this is doing, check out the [source
> code](https://github.com/topicdesign/topkit-cli/blob/v1.0/bin/ripen).

Secure It!
----------

At this point, we usually lock down SSH at root login.

When doing this, it's best to open a new terminal window and test your settings
so you don't lock yourself out of your server forever!

Ideally, you're only logging into the server as the `topkit` user from now on.

Install Topkit CLI
----------

The Topkit CLI (command-line interface) is what helps us work with the Topkit
Server application. Begin by installing the CLI tool. You should do this as the `topkit` user.

```text
$ gem install topkit --no-ri --no-rdoc
```

Since you're using `rbenv` for managing rubies, you need to reload the
executables:

```text
$ rbenv rehash
```

Install Topkit
----------

This part is a little tricky. We want to run the install action as the `root`
user, but you don't need to re-SSH into the server. You can sign in as that
user like so:

```text
$ sudo su -
```

Now, let's make sure that user has access to our programs:

```text
$ cd /home/topkit
$ export HOME=/home/topkit
$ source .bashrc
```

And finally, we should be able to install our Topkit Server application:

```text
$ topkit install server
```

This will ask you some questions along the way. When you're done, the app will
be running at the domain you specified.
