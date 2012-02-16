module GrepFu
  class FindBuilder
    PRUNE_PATHS = ['/.svn', '/.git', '/vendor', '/log',
                   '/public', '/tmp', '/coverage', '/doc']

    def self.delicious_prunes
      "-path '*#{PRUNE_PATHS.join("' -prune -o -path '*")}' -prune -o"
    end

    def self.find_command(options)
      [
        'find',
        options.file_path,
        delicious_prunes,
        "\\( -size -100000c -type f \\) -print0 | xargs -0 grep",
        options.to_s,
        "\"#{options.search_criteria}\""
      ].join(' ')
    end
  end
end
