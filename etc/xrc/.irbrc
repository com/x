# encoding: utf-8
Dir[File.join(ENV['X'], 'etc', 'irb', "*.rb")].sort.each do |file|
  begin; require file; rescue LoadError; end
end
