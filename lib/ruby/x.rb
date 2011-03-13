# encoding: utf-8

module X
  def self.require_all(dir)
    $:.map  { |path| File.join(path, "#{dir}/*.rb") }
      .map  { |glob| Dir[glob] }.flatten
      .each { |file| require file }
  end
  def self.require_all_available(dir)
    $:.map  { |path| File.join(path, "#{dir}/*.rb") }
      .map  { |glob| Dir[glob] }.flatten
      .each { |file| begin; require file; rescue LoadError; end }
  end
end
