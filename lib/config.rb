require 'yaml'
require 'ostruct'

module RSSDownloader
  class Config
    attr_reader :dests

    def initialize(path)
      yaml = YAML.load(File.read(path))

      @dests = yaml['dests'].map do |dest|
        OpenStruct.new(dir: dest['dir'], feeds: dest['feeds'])
      end
    end
  end
end