# Moves Backups

This is a tiny applicaiton that backs up your data from [Moves](http://www.moves-app.com). All it does is grab `/users/storyline/<date>?trackPoints=true<`
and shoves it into a database table named `moves_days` keyed on `day`. The data lives in a column named `json`
and is the literal JSON string returned from the API.

Then, to set up on Heroku:

```bash
$ git clone https://github.com/peterkeen/moves-backup
$ cd moves-backup
$ heroku create
$ git push heroku master
$ heroku open
```

Now login to the [Moves dev site](https://dev.moves-app.com) and create an application. Use the Heroku URL as the Redirect URI. Make sure to use HTTPS! Now set some config variables:

```bash
$ heroku config:set MOVES_CLIENT_ID=your_client_id MOVES_CLIENT_SECRET=your_client_secret USERNAME=your_basic_auth_username PASSWORD=your_basic_auth_password
```

Login with your basic auth username and password and click the big blue button that says "Authorize with Moves" and then follow the instructions. It'll tell you to set an environment variable named <code>MOVES_ACCESS_TOKEN</code>, just set that in another config variable.

Run the inital fetch:

```
$ heroku run rake fetch
```

This shouldn't print anything out, but if you refresh the page you should see some data under "Backed Up Days". Clicking on those links will give you the raw JSON.

Now, add backups and set up the fetch schedule:

```bash
$ heroku addons:add pgbackups:auto-month
$ heroku addons:add scheduler
$ heroku addons:open scheduler
```

Add an daily job that runs `rake fetch`.

Now, what you do with this data? That's up to you :) Enjoy!

----

This application uses data from Moves but is not endorsed or certified by Moves. Moves is a trademark of ProtoGeo Oy.
