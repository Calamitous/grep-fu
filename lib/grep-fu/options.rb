module GrepFu
	class Options
		attr_reader :verbose, :single_line, :color, :search_criteria, :file_path 

		PATH_REPLACEMENTS = {
			'a' => 'app', 
			'c' => 'app/controllers', 
			'h' => 'app/helpers', 
			'm' => 'app/models', 
			'v' => 'app/views', 
			'l' => 'lib',
			'p' => 'public', 
			'css' => 'public/stylesheets', 
			'js' => 'public/javascripts', 
			't' => 'test',
			's' => 'spec',
			'vp' => 'vendor/plugins',
			'mig' => 'db/migrate'
		}

		COLOR_ON_BY_DEFAULT = false

		def self.usage(file)
			lines = ['',
				"Usage: #{file} [findpath] search_string [--verbose|--single-line]\n",
				"    Where findpath is one of the following:",
				"      any literal subdirectory",
				Options::PATH_REPLACEMENTS.map { |abbr, txt| "      #{abbr} - #{txt}" }.join("\n"),
			"\n\n"
			]

			lines.join("\n")
		end

		def initialize(args)
			if args.include?('--version')
				puts "grep-fu #{File.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION'))}"
				exit(0)
			end

			@verbose = (args -= ['--verbose'] if args.include?('--verbose'))
			@single_line = (args -= ['--single-line'] if args.include?('--single-line'))

			@color = (args -= ['--color'] if (args.include?('--color')) || COLOR_ON_BY_DEFAULT)
			if args.include?('--no-color')
				args -= ['--no-color']
				@color = false
			end

			@search_criteria = args.last
			@file_path = args.size == 2 ? PATH_REPLACEMENTS[args.first] || args.first : './'
		end

		def to_s
			options = @verbose ? '-rin' : '-ril'
			options << ' --color=always' if @color
			options
		end

	end
end
