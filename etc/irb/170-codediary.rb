# Copyright ©, 2010 roktas -*-encoding: utf-8-*-
# Licensed under WTFPL http://sam.zoy.org/wtfpl/

require 'highline'
require 'interactive_editor'

# XXX  Just an half-assed implementation
# TODO Generalize and redesign to whole beast

module X
  class CodeDiary

    class Uninitiated < StandardError; end
    class NotFound    < StandardError; end

    def initialize(option={})
      [:diarydir, :ext, :seed].each do |opt|
        unless option[opt]
          raise "Option #{opt} is missing."
        end
      end

      @diary     = {}
      @cursor    = option[:cursor]
      @diarydir  = option[:diarydir]
      @ext       = option[:ext]
      @seed      = option[:seed]
      @formatter = option[:formatter]

      unless @seed.respond_to? :succ
        raise "Seed must be sequencable."
      end

      unless @seed.respond_to? :to_sym
        @seed.class.class_eval <<-EOS, __FILE__, __LINE__ + 1
          def to_sym
            self.to_s.to_sym
          end
        EOS
      end
    end

    def refresh
      @diary.clear
      Dir[to_filename('*')]
        .sort
        .each { |f| @diary[to_key(f)] = f }
    end

    def get(arg=nil)
      refresh

      if arg
          self[arg] or raise NotFound, arg
      else
        if cursor.nil?
          if @diary.size == 0
            raise Uninitiated
          else
            last_modified = diary_sorted_by_modification.values.last
          end
        else
          cursor
        end
      end
    end

    def get!(arg=nil)
      self.cursor = get(arg)
    end

    def new
      self.cursor = newfile
    end

    # TODO other sorts
    def choose
      refresh

      choices = diary_sorted_by_modification.values.reverse
      if choices.empty?
        warn "Havuzda dosya yok.  Önce bir dosya oluşturun."
      else
        terminal = HighLine.new

        terminal.choose do |menu|
          menu.default = "1"
          # XXX UTF-8 problems
          menu.prompt = "Hangisi [#{menu.default}] ? "
          menu.choices(*choices) { |choosen| return choosen }
        end
      end

      nil
    end

    protected

    attr_accessor :cursor

    private

    def [](arg)
        if arg.kind_of?(Symbol)
          symbol_to_file(arg)
        elsif arg.kind_of?(String)
          string_to_file(arg)
        elsif arg.kind_of?(Integer)
          num_to_file(arg)
        else
          raise TypeError, "Symbol, String or Number expected"
        end
    end

    def newfile
      refresh

      try = @seed

      ntry = 1000

      key, file =
        while ntry > 0
          file = to_filename(format(try.to_s))
          key = to_key(file)
          break [key, file] unless @diary[key]
          try = try.succ
          ntry -= 1
        end

      raise "No succeeding file computed" unless ntry > 0

      FileUtils.mkdir_p File.dirname(file)
      FileUtils.touch file
      @diary[key] = file

      file
    end

    def to_key(filename)
      File.basename(filename.to_s, @ext).to_sym
    end

    def format(key)
      name = key.to_s
      name = @formatter ? @formatter.call(name) : name
    end

    def to_filename(key)
      File.join(@diarydir, format(key) + @ext)
    end

    def symbol_to_file(symbol)
      @diary[symbol]
    end

    def string_to_file(string)
      string += @ext unless File.extname(string) == @ext
      @diary.rassoc(string) ? string : nil
    end

    def num_to_file(num)
      pair = @diary.to_a[num > 0 ? num - 1 : 0]
      pair.last if pair
    end

    def diary_sorted_by_modification
      Hash[
        @diary.collect do |key, file|
          [test(?M, file), key, file]
        end.sort.collect { |a| a[1..-1] }
      ]
    end
  end
end

module X
  module Irb
    module Config
      BASEDIR = File.join(ENV['HOME'], 'C')
      SLUG    = File.join('ruby', Time.now.strftime('%F'))
      EXT     = '.rb'
      SEED    = 'a'

      @@basedir = BASEDIR
      def self.basedir
        @@basedir
      end
      def self.basedir=(directory)
        @@basedir = directory
      end

      @@slug = SLUG
      def self.slug
        @@slug
      end
      def self.slug=(directory)
        @@slug = directory
      end

      @@seed = SEED
      def self.seed
        @@seed
      end
      def self.seed=(seed)
        @@seed = seed
      end
    end

    def self.diary
      @@codediary = ::X::CodeDiary.new(
        :ext      => Config::EXT,
        :diarydir => File.join(Config.basedir, Config.slug),
        :seed     => Config.seed,
      )
    end

    def e(arg=nil)
      invoke_editor { ed @@codediary.get arg  }
    end

    def e!(arg=nil)
      if arg
        invoke_editor { ed @@codediary.get! arg }
      else
        invoke_editor { ed @@codediary.new }
      end
    end
    def e?(arg=nil)
      invoke_editor do
        choosen = @@codediary.choose
        ed @@codediary.get! choosen if choosen
      end
    end

    private

    def invoke_editor(&block)
      block.call
    rescue ::X::CodeDiary::Uninitiated
      ed @@codediary.new
    rescue ::X::CodeDiary::NotFound => e
      warn "Havuzda dosya bulunamadı: #{e.message}"
    end

  end
end

X::Irb.diary
include X::Irb
