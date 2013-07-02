# Moves Backups
This is a tiny applicaiton that backs up your data from Moves App. All it does is grab <code>/users/storyline/<date>?trackPoints=true</code>
and shoves it into a database table named <code>moves_days</code> keyed on <code>day</code>. The data lives in a column named <code>json</code>
and is the literal JSON string returned from Moves.

To get started, login to the [Moves dev site](https://dev.moves-app.com) and create an application.

Then, to set up on Heroku:

```bash
$ git clone https://github.com/peterkeen/moves-backup
$ cd moves-backup
$ heroku create
$ heroku config:set MOVES_CLIENT_ID=your_client_id MOVES_CLIENT_SECRET=your_client_secret USERNAME=your_basic_auth_username PASSWORD=your_basic_auth_password
$ heroku open
```

Login with your basic auth username and password and click the big blue button that says "Authorize with Moves" and then follow the instructions. It'll tell you to set an environment variable named <code>MOVES_ACCESS_TOKEN</code>, just set that in another config variable.

Now, set up the fetch schedule:

```bash
$ heroku addons:add scheduler
```
