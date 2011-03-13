# encoding: utf-8

if STDIN.isatty
  require "highline"
  require "forwardable"

  class HighLine
    def whisper(*args, &block)
      ask(*args) { |q| q.echo = false; yield q if block_given? }
    end
    def pause(*args)
      say(*args) if args.size > 0; SystemExtensions::get_character
    end

    class Menu
      alias :update_responses_orig :update_responses
      def update_responses(*args)
        update_responses_orig(*args)
        @responses = {
          :ambiguous_completion =>
            "Seçim belirsiz.  Lütfen şu seçeneklerden birini seçin: #{options.inspect}.",
          :ask_on_error         =>
            "?  ",
          :invalid_type         =>
            "Geçerli bir #{options} girmelisiniz.",
          :no_completion        =>
            "Şu seçeneklerden birini seçmelisiniz: #{options.inspect}.",
          :not_in_range         =>
            "Cevabınız #{expected_range} aralığında olmalı." ,
          :not_valid            =>
            "Geçersiz girdi: #{@validate.inspect} ile uyumlu olmalı."
        }
      end
    end

    class Question
      alias :build_responses_orig :build_responses
      def build_responses(*args)
        build_responses_orig(*args)
        @responses = {
          :ambiguous_completion =>
            "Seçim belirsiz.  Lütfen şu seçeneklerden birini seçin: #{@answer_type.inspect}.",
          :ask_on_error         =>
            "?  ",
          :invalid_type         =>
            "Geçerli bir #{@answer_type} girmelisiniz.",
          :no_completion        =>
            "Şu seçeneklerden birini seçmelisiniz: #{@answer_type.inspect}.",
          :not_in_range         =>
            "Cevabınız #{expected_range} aralığında olmalı." ,
          :not_valid            =>
            "Geçersiz girdi: #{@validate.inspect} ile uyumlu olmalı."
        }
      end
    end
  end

  HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
    cs[:headline] = [ :bold, :yellow, :on_black ]
    cs[:error]    = [ :red, :on_black ]
    cs[:warning]  = [ :magenta, :on_black ]
    cs[:notice]   = [ :bold, :cyan, :on_black ]
    cs[:info]     = [ :bold, :white, :on_black ]
    cs[:ok]       = [ :bold, :green, :on_black ]
    cs[:notok]    = [ :bold, :red, :on_black ]
    cs[:special]  = [ :bold, :blue, :on_black ]
  end

  $terminal = HighLine.new

  module X
    module Util
      METHODS = [:agree, :ask, :choose, :say, :whisper, :pause, :color]
      def self.included(base)
        base.class_eval do
            extend Forwardable
            def_delegators :$terminal, *METHODS
        end
      end
    end
  end
end
