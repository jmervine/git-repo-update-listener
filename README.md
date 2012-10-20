# USAGE

    $ git clone http://github.com/jmervine/git-repo-update-listener.git listener
    $ cd listener
    $ bundle install --path ./vendor/bundle
    $ cp conig/config.yml.example config/config.yml

    # update config/config.yml to match your app

    $ bundle exec ./listener start

Logs to: `log/listner.log`
