# Archaic #

By Andrew De Ponte (a.k.a. cyphactor)

Archaic is a simple Rails front-end application combined with a Cinch based
IRC Bot that is designed to assist in archiving and analyzing a chat history.
The Rails web interface simply provides views for viewing and analyzing the
chats that the IRC Bot records.

## Getting Started ##

### Install Dependencies & Migrating Database ###

First things first you of course have to install all of the dependencies
using bundler. This can be done with the following command at the root of
the project:

    bundle install
    
Once all the dependencies have successfully been installed you then need to
make sure that the database schema is up to date. This is done by running the
following:

    rake db:migrate
    
### Configuring Archaic ###

To configure Archaic you need to create a configuration file called
ArchaicConfig.rb in the projects config folder. This file is ignored by the
git repository and is not intended to be tracked. It is specifically here
for you to have your own personal Archaic configurations in. The
config/ArchaicConfig.rb file should look something like the following:

    require 'archaic_config'

    Archaic.config do |c|
      c.irc_nick = "dev_arch_bot"
      c.irc_server = "irc.freenode.net"
      c.irc_channels = ["#archaic_dev"]
      c.ticket_url = "http://github.com/cyphactor/archaic/issues#issue/:ticket_id"

      c.brew_url = 'http://www.tustinbrewery.com/'
      c.brew_regex = /<div class="brew-name">(.*?)<\/div>/
      c.brews_to_hide = [/guest beers:/, /\*Check out our bottle list/]
    end

Please replace the values for each of the configuration options shown above
with the values that are appropriate for you. The above are simply the default
values that are used in the case where you neglet to provide a
config/ArchaicConfig.rb file.

### Launching/Monitoring the Archaic IRC Bot Daemon ###

Once you have installed all the dependencies, migrated the database, and
configured Archaic you are ready to run launch and monitor the Archaic IRC
Bot Daemon.

Currently Archaic is split into two main components the front-end Rails
application portion of things and the backend IRC Bot portion. The IRC Bot
portion is a daemon process that is managed by god. Therefore, you can kick
it off and god's monitoring of it by doing the following:

    god -c config/archaic.god
    
The above should startup god if its not running and god should then startup
and start monitoring the archaic irc bot. You can see the status of things
with respect to god by running the following:

    god status
    
If you are interesting in seeing what god is doing with respect to the archaic
irc bot you can run the following:

    god log archaic-irc-bot

### Running the Rails App Front-end ###

The Rails application portion should be run as any other rails application
would be. In development it is as simple as the following:

    rails server

## Runtime Dependencies ##

* rails-3.0.3
* sqlite3-ruby
* cinch
* daemons
* god
