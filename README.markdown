# Archaic #

By Andrew De Ponte (a.k.a. cyphactor)

Archaic is a simple Rails front-end application combined with a Cinch based
IRC Bot that is designed to assist in archiving and analyzing a chat history.
The Rails web interface simply provides views for viewing and analyzing the
chats that the IRC Bot records.

## Getting Started ##

Currently Archaic is split into two main components the front-end Rails
application portion of things and the backend IRC Bot portion. The IRC Bot
portion is required to run in the Rails application environment. Hence, it
needs to be run with script runner as follows:

    rails runner lib/irc_bot.rb

The Rails application portion should be run as any other rails application
would be. In development it is as simple as the following:

    rails server

Oh, and don't forget you need to migrate the database as usual with the follow
command.

    rake db:migrate

## Runtime Dependencies ##

* rails-3.0.3
* sqlite3-ruby
* cinch
