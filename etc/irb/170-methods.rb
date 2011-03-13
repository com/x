class Object
  # Return only the methods not present on basic objects
  def interesting_methods
    (self.methods - Object.new.methods).sort
  end
end

# http://stackoverflow.com/questions/123494/whats-your-favourite-irb-trick/123834#123834
def quick(repetitions=100, &block)
  require 'benchmark'

  Benchmark.bmbm do |b|
    b.report {repetitions.times &block}
  end
  nil
end
