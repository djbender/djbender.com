---
published: true
layout: default

---

## Manually Backup Heroku Postgres when pgbackups:capture Flakes Out

Today, `heroku pgbackups:capture` wouldn't work. It would start and then never complete. While I've got a support ticket up I needed a way to download my production data _now_. Here's what I've come up with:

To export your database check your app's Config Vars with `heroku config`:

    $ PGPASSWORD=<password> pg_dump -Fc --no-acl --no-owner -h <host-url> -U <user> <database> > latest.dump

To import to your local postgres server simply use `pg_restore`:

    $ pg_restore --verbose --clean --no-acl --no-owner -h localhost -d <database> latest.dump

It's important to not the `--no-acl --no-owner` flags as this will allow you to import to your production database's content without attempting to use production's gibberish roles.
