= git-presenter

When presenting code live on stage you have a few choices:
* Change code live on stage and risk making a mistake and the code not working.
* Place code in a slide and not be able to run the code live.

Git-presenter hope to solve this problem by giving a presentation style interface for your code.

== Current status

In Development

== Pre-requisites

* Git
* Ruby

== Installation

gem install git-presenter

== Usage

Commit to git as you develop you code.
When the code is ready use the gpresenter init command to initialise
Use gpres start to revert to the first commit
Use gpres next to move forward throught the commits
Use gpres prev to move to the previous commit

== Contributing to git-presenter

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2011 Colin Gemmell. See LICENSE.txt for
further details.

