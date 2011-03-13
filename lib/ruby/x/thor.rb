# encoding: utf-8

require 'x/util/all'
require 'pathname'
require 'fileutils'
include FileUtils

Signal.trap("INT") { puts; exit }

class Thor;        include Thor::Actions; end
class Thor::Group; include Thor::Actions; end
