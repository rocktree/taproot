The [Sapwood code](https://github.com/seancdavis/sapwood) is hosted publicly on GitHub. Its various branches are used for managing different segments or versions of the application.

If you have followed [this guide](/docs/getting_started/production_environment) to setting up your production environment, then you are likely working from the `release` branch (if you're not, you should be).

Updating Production
----------------

Because the process of updating sapwood is somewhat involved, we've packaged up the tasks in a rake task so it's easy for you to manage.

```text
$ RAILS_ENV=production bundle exec rake sapwood:update
```

This will bring your app to the current version. It essentially just pulls the `release` branch, and then reloads everything it needs to reload.

If you run in to problems here, you may have to manually restart some services.

### Sidekiq

We use [Sidekiq](http://sidekiq.org/) to manage our background processes. If pulling project repos is not working, it's likely this services is not running. There is a rake task for restarting sidekiq.

```text
$ RAILS_ENV=production bundle exec rake sapwood:restart_sidekiq
```

### Rails Server

If some changes didn't take effect, or you can't get to the site, you probably want to restart your rails server while there is a `restart_server` command, you should probably stop and start it to be safe.

```text
$ RAILS_ENV=production bundle exec rake sapwood:stop_server
$ RAILS_ENV=production bundle exec rake sapwood:start_server
```

> **It is important that when you update the production application, you inform your team and ensure all development environments are up to date.** You will want to always ensure your development and production environments are using the same version (meaning sharing the latest commit to the stable branch).

Updating Development
----------------

In development, you can run the update rake task (without the `RAILS_ENV=production`), but it doesn't give you much in development. It's easier to just pull the repo and then restart your rails server.

```text
$ git pull origin v1-stable
$ bundle exec rails s
```
