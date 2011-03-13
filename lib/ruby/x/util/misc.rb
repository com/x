# encoding: utf-8

require 'yaml'
require 'open-uri'

begin; gem 'inifile'; rescue LoadError; end
autoload :IniFile, 'inifile'

module X
  module Util
    module_function
  end
end

module YAML
  def self.fetch(uri)
      open(uri) { |f| YAML::load(f) }
  end
end
