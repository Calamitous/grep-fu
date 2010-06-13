Grep-Fu
=======

Grep-Fu is a very fast, Rails-oriented command-line helper script for grep.  It's a ruby wrapper for speeding up text searches within the files of a Rails project.  The simplest, common usage:

    grep-fu account_deletion

This will display a list of files which contain the search text:

    ./app/models/account.rb
    ./app/controllers/accounts_controller.rb

*NOTE:* Grep-Fu will only work as expected if you are in the root directory of a Rails project!

Installation
------------

Grep-Fu is now a gem:

    gem install grep-fu

Often, it can help reduce typing by aliasing the admittedly lengthy "grep-fu" command:

    alias g='grep-fu'

Putting this (or a similar shortcut) in your .bashrc or .profile will allow you to use a shorthand version of the command:

    g account_deletion

Even Faster
-----------

For more targeted (faster) searches, you can specify one of the following flags to narrow down the search:

      a - app
      m - app/models
      c - app/controllers
      v - app/views
      h - app/helpers

      l - lib

      p - public
      css - public/stylesheets
      js - public/javascripts

      s - spec
      t - test

      vp - vendor/plugins
      mig - db/migrate

So to search only your helpers for the term "helpless":

    grep-fu h helpless

Multiple word searches and searches containing special regex characters should be surrounded by quotes:

    grep-fu s "should be tested"

    grep-fu "^[^\?] fishy fishy fishy fish$"

Running grep-fu without parameters will show you what options are available.

Off the Beaten Path
----------------------------

Occasionally, you'll want to search a directory that's not defined in one of the targeted paths, but you don't want to scan the entire Rails project.  In that case, you can provide a specific directory to grep:

    grep-fu lib/tasks troweler

You can even step up out of the current directory.  Grep-Fu will use any path shortcuts your underlying OS recognizes.

    grep-fu ../../different_rails_project "def similar_method"

    grep-fu ~/Projects/roger_tracking last_known_location

I want to see what it found!
----------------------------

For more detail, you can add the '--verbose' flag to command:

    grep-fu c budget_dragon --verbose

This will output the filename, line number, and found line.

    ./app/model/budget.rb:18:
      budget_dragon # Bob in accounting's been drinking again

This should be used for fairly narrow searches, as it can produce a whole lot of output.

Thanks go out to [Scotty Moon](http://github.com/scottymoon) for this feature.

Colors
------

If you'd like to see grep-fu's output in color, add the '--color' flag:

    grep-fu mig ExtraBiggened --color --verbose

Under most color schemes, the --color option is only useful if --verbose is used as well.

If you'd rather have color all the time, you can change the setting COLOR_ON_BY_DEFAULT in the code to true.  If you do this, then you can use the '--no-color' flag to disable the feature:

    grep-fu mig DoublePlusUnBiggened --no-color

Thanks go out to [Joshua French](http://github.com/osake) for this feature.

Single-Line Output
------------------

Sometimes you need to output all the files grep-fu finds onto a single line; for example, when piping the list into another command:

    grep-fu "# Pipe me!" --single-line

The list of files with matches will display on a single line:

    ./test/unit/calamity_test.rb ./test/unit/havoc_test.rb ./test/unit/mayhem_test.rb...

Ignoring More Stuff
---------------------

When performing an untargeted search, Grep-fu determines which directories to skip by using the PRUNE_PATHS constant.  If you have a directory you'd like to skip searching by default, simply add its path (relative to the Rails root) to PRUNE_PATHS.

For example, if you have an unusually large set of migrations, you might want to step over them by default.  Change the line

    PRUNE_PATHS = ['/.svn', '/.git', '/vendor', '/log', '/public', '/tmp', '/coverage']

to

    PRUNE_PATHS = ['/.svn', '/.git', '/vendor', '/log', '/public', '/tmp', '/coverage', '/db/migrations']

And migrations will no longer be searched.  Note that targeted searches and specified directories always override the PRUNE_PATHS option.

Technical mumbo-jumbo
---------------------

Grep-Fu speeds up the searching process by only searching the files you care about.  It does this by constructing a "find" command which is piped into grep.  Find "prunes" the following search directories:

 * public
 * logs
 * vendor
 * tmp
 * coverage
 * .svn
 * .git

Note that all these directories are still searchable with targeted searches or a directory specification; they're simply not searched by default

Grep-fu also ignores files larger than 100K, which tend to be unsearchable binaries or SQL dumps.

The pruning options for find are some of the ugliest in the CLI world.  Using Ruby allows us to construct a giant, hideous command that does exactly what we need.

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010 Eric Budd. See LICENSE for details.
