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

So to search only your helpers for the term "helpless":

	grep-fu h helpless

Multiple word searches should be surrounded by quotes:

	grep-fu s "it should be tested"

Running grep-fu without a search will show all available options.

I want to see what it found!
----------------------------

For more detail, you can add the '--verbose' flag to command:

	grep-fu c budget_dragon --verbose

This will output the filename, line number, and found line.  This should be used for fairly narrow searches, as it can produce a whole lot of output.

Thanks go out to [Scotty Moon]: http://github.com/scottymoon for this feature.

Technical mumbo-jumbo
---------------------

Grep-Fu speeds up the searching process by only searching the files you care about.  It does this by constructing a find for grepping which "prunes" unwanted directories, such as logs and vendor plugins.  Unfortunately, find's prune options are some of the ugliest in the CLI world.  Using Ruby allows us to construct a giant ugly command that does exactly what we want.



