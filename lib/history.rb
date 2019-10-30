require 'set'
require 'fileutils'

module RSSDownloader
  class History
    def initialize(path)
      @path = File.expand_path(path)

      FileUtils.touch(@path)
      @url_set = File.read(@path).split.to_set
    end

    def contains?(url)
      @url_set.include?(url)
    end

    def <<(url)
      @url_set << url

      open(@path, 'a') do |f|
        f.write("#{url}\n")
      end
    end
  end
end