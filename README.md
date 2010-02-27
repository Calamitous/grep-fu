Grep-Fu
=======

Grep-Fu is a very fast, Rails-oriented command-line helper script for grep.  It's a ruby wrapper for grep for speeding up text searches within the files of a Rails project.  The simplest, common usage:

	grep-fu "def account_deletion"

*IMPORTANT:* Grep-Fu will only work as expected if you are in the root directory of a Rails project!

It's a standalone script, so you can just drop it in any PATHed directory, chmod 777 it (or 700, for the paranoid) and go to town.

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

Running grep-fu without a search will show you what options are available.

I want to see what it found!
----------------------------

For more detail, you can add the '--verbose' flag to command:

	grep-fu c budget_dragon --verbose

This will output the filename, line number, and found line.  This should be used for fairly narrow searches, as it can produce a whole lot of output.

Thanks go out to [Scotty Moon](http://github.com/scottymoon) for this feature.

Colors
------

If you'd like to see grep-fu's output in color, add the '--color' flag to your output:

 	grep-fu mig ExtraBiggened --color --verbose

This will output your results in color.  If you'd rather just leave color on all the time, you can change the setting COLOR_ON_BY_DEFAULT in the code to true.  If you do this, then you can use the '--no-color' flag to disable the feature:

 	grep-fu mig DoublePlusUnBiggened --no-color

Thanks go out to [Joshua French](http://github.com/osake) for this feature.


Technical mumbo-jumbo
---------------------

Grep-Fu speeds up the searching process by only searching the files you care about.  It does this by constructing a find for grepping which "prunes" unwanted directories, such as logs and vendor plugins.  Unfortunately, find's prune options are some of the ugliest in the CLI world.  Using Ruby allows us to construct a giant ugly command that does exactly what we want.



