require 'grep-fu/options'
require 'grep-fu/find_builder'

module GrepFu
	def self.run!(args = [])
		unless args.size > 0
			puts Options.usage(__FILE__)
			exit
		end

		options = Options.new(args)

		find_command = FindBuilder.find_command(options)
		puts find_command

		if options.verbose
			`#{find_command}`.each_line do |found|
				file_and_line = found.slice!(/^.*?:.*?:/)
				puts "#{file_and_line}\n\t#{found.strip}"
			end
		elsif options.single_line
			puts `#{find_command}`.map { |found| found.chomp }.join(' ')
		else
			puts `#{find_command}`
		end
	end
end
