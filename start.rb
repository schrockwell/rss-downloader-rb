#! /usr/bin/env ruby

require_relative 'lib/config'
require_relative 'lib/history'

require 'optparse'
require 'open-uri'
require 'rss'

config = RSSDownloader::Config.new("config.yml")

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: check.rb [options]"

  opts.on('-s', '--skip-download', "Don't actually download anything, but still update history") do |s|
    options[:skip] = s
  end
end.parse!

config.dests.each do |dest|
  FileUtils.mkdir_p(dest.dir)

  Dir.chdir(dest.dir) do
    history = RSSDownloader::History.new(".history")

    dest.feeds.each do |feed_url|
      open(feed_url) do |rss|
        feed = RSS::Parser.parse(rss)
        puts "Loading feed #{feed.channel.title}..."

        feed.items.each do |item|
          next if history.contains?(item.link)

          puts "New file: #{item.title}"

          if options[:skip]
            ok = true
          else
            ok = system('/usr/local/bin/wget', '-N', '-q', '--content-disposition', item.link)
          end

          if ok
            history << item.link
          else
            puts "Error downloading #{item.title}"
          end
        end
      end
    end
  end
end

