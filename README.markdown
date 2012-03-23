# git-presenter

[![Build Status](https://secure.travis-ci.org/pythonandchips/git-presenter.png?branch=master)](http://travis-ci.org/pythonandchips/git-presenter)

When presenting code live on stage you have a few choices:

* Change code live on stage and risk making a mistake and the code not working.
* Place code in a slide and not be able to run the code live.

Git-presenter hope to solve this problem by giving a presentation style interface for your code.

## Current status

Early version but the basics are there to be used.
Any and all feedback is welcome

## Pre-requisites

* Git
* Ruby version 1.9.2 or 1.9.3 or jruby in 1.9 mode (basically anything with 1.9 at the end)

## Installation

gem install git_presenter

## Usage

* Commit to git as you develop your code.
* When the code is ready use the "git-presenter init" command to initialise
* Once it is initialised you can start the presentation with "git-presenter start"
* Then use the following command to navigate the presentation
* next/n: move to next slide
* back/b: move back a slide
* end/e:  move to end of presentation
* start/s: move to start of presentation
* list/l : list slides in presentation
* help/h: display this message

##Changelog

* 22 March 2012
  - added exit method
  - added checkout to make sure presentation can continue if files have been edited

## Contributing to git-presenter

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Colin Gemmell

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

