# encoding: utf-8

require 'thor/actions'
require 'fileutils'
require 'tmpdir'

class Thor
  module Shell
    DELEGATED = [:y?, :n?, :no?, :yes_default?, :ask_default]

    DELEGATED.each do |method|
      module_eval <<-METHOD, __FILE__, __LINE__
        def #{method}(*args)
          shell.#{method}(*args)
        end
      METHOD
    end

    class Basic
      def y?(s); !!(s =~ is?(:yes) || s =~ is?(:evet));   end
      def n?(s); !!(s =~ is?(:no) || s =~ is?(:'hayır')); end

      def yes?(*args); y?(ask(*args)); end
      def no?(*args);  n?(ask(*args)); end

      def yes_default?(*args)
        reply = ask(*args)
        !!(reply.nil? || reply.empty? || y?(reply))
      end

      def ask_default(*args)
        reply = ask(*args)
        return reply unless reply.empty?
        default = (args[0].scan(/\[([^\]]+)\]/).last || []).last || ''
        return default
      end
    end
  end

  module Actions
    def in_tempdir(config={})
      dir = Dir.mktmpdir config.delete(:prefix_suffix), config.delete(:tmpdir)
      is_keep = config.delete(:keep)
      begin
        inside(dir, config) { yield dir }
      ensure
        FileUtils.remove_entry_secure(dir) unless is_keep
      end
    end
    def template_string(source, destination, *args, &block)
      config = args.last.is_a?(Hash) ? args.pop : {}

      context = instance_eval('binding')

      create_file destination, nil, config do
        content = ERB.new(source, nil, '-', '@output_buffer').result(context)
        content = block.call(content) if block
        content
      end
    end
  end

  module Util
    module_function

    def load_thorfiles_from(*dirs)
      dirs.each do |path|
          Thor::Util.globs_for(path)
          .map  { |glob| Dir[glob] }.flatten
          .each { |file| Thor::Util.load_thorfile file }
      end
    end
  end
end
