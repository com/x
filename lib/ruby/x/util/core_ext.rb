# encoding: utf-8

require 'yaml'

begin
  require 'ya2yaml'
rescue LoadError
end

class Hash
  def deep_stringify_keys
    dest = {}
    self.each do |key, value|
      dest.merge! key.to_s => value.is_a?(Hash) ? value.deep_stringify_keys : value
    end
    dest
  end
  def deep_symbolize_keys
    dest = {}
    self.each do |key, value|
      dest.merge!(
        ((key.to_sym rescue key) || key) => value.is_a?(Hash) ? value.deep_symbolize_keys : value
      )
    end
    dest
  end

  def stringify_as_yaml(filename=nil, header=nil)
    string = self.deep_stringify_keys.send(hash.respond_to?(:ya2yaml) ? :ya2yaml : :to_yaml)
      .gsub("!ruby/symbol ", ":")
      .sub("---", "")
      .split("\n")
      .map(&:rstrip)
      .join("\n")
      .strip
  end

  def write_as_yaml(filename=nil, header=nil)
    string = (header ? "#{header}\n" : '') + self.stringify_as_yaml
    filename ? File.open(filename, "w") { |f| f.write(string) } : puts(string)
  end

  # Return a new hash with all keys converted to strings.
  def stringify_keys
    dup.stringify_keys!
  end

  # Destructively convert all keys to strings.
  def stringify_keys!
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end

  # Return a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+.
  def symbolize_keys
    dup.symbolize_keys!
  end

  # Destructively convert all keys to symbols, as long as they respond
  # to +to_sym+.
  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end

  alias_method :to_options,  :symbolize_keys
  alias_method :to_options!, :symbolize_keys!

  # Validate all keys in a hash match *valid keys, raising ArgumentError on a mismatch.
  # Note that keys are NOT treated indifferently, meaning if you use strings for keys but assert symbols
  # as keys, this will fail.
  #
  # ==== Examples
  #   { :name => "Rob", :years => "28" }.assert_valid_keys(:name, :age) # => raises "ArgumentError: Unknown key: years"
  #   { :name => "Rob", :age => "28" }.assert_valid_keys("name", "age") # => raises "ArgumentError: Unknown key: name"
  #   { :name => "Rob", :age => "28" }.assert_valid_keys(:name, :age) # => passes, raises nothing
  def assert_valid_keys(*valid_keys)
    valid_keys.flatten!
    each_key do |k|
      raise(ArgumentError, "Unknown key: #{k}") unless valid_keys.include?(k)
    end
  end
end
