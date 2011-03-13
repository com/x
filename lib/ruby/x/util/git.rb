# encoding: utf-8

require 'x/util/core_ext'

begin; gem 'grit'; rescue LoadError; end
autoload :Grit, 'grit'

begin; gem 'octopussy'; rescue LoadError; end
autoload :Octopussy, 'octopussy'

module X
  module Util
    module Git
      CONFIG_MAP = {
        :login => %w(GITHUB_USER      github.user),
        :token => %w(GITHUB_TOKEN     github.token),
        :name  => %w(GIT_AUTHOR_NAME  user.name),
        :email => %w(GIT_AUTHOR_EMAIL user.email),

      }

      class << self
        def config(given)
          unless CONFIG_MAP.has_key? given
            raise ArgumentError, "Verilen '#{given}' anahtarı desteklenen #{CONFIG_MAP.keys} anahtarlarından biri değil."
          else
            @@config[given] || ''
          end
        rescue NameError
          @@config = {}
          CONFIG_MAP.each do |key, sources|
            env, ini = *sources
            value = ENV[env]
            if value.nil? || value.empty?
              value =  %x(git config --global --get #{ini} 2>/dev/null).chomp
            end
            @@config[key] = value
          end
          @@config[given]
        end

        def ensure_configured(&block)
          missing = CONFIG_MAP.select do |key, sources|
            value = config(key)
            value.nil? || value.empty?
          end
          unless missing.nil? || missing.empty?
            block_given? ? yield(missing) : exit_missing(missing)
          end
        end

        def exit_missing(missing)
          $stderr.puts 'Bazı Git ayarları eksik.  Lütfen aşağıdaki talimatları izleyerek bu ayarları tamamlayın:'
          missing.each do |key, sources|
            env, ini = *sources
            $stderr.puts
            $stderr.puts "  '#{key}' için '#{env}' ortam değişkeni veya 'git config --global #{ini} <DEĞER>' komutunu kullanın."
          end
          exit 1
        end
      end
    end

    # Simplistic helpers for Github scripting.  Please use a full blown gem
    # for complex scenarios.

    module Github
      FMT_URL = {
        :http => 'https://github.com/%s/%s',
        :git  => 'git://github.com/%s/%s',
        :ssh  => 'git@github.com:%s/%s',
      }

      FMT_FILE = '/raw/%s/%s'

      def uri(*args)
        if args.size % 2 == 0
          option = Hash[*args]
        else
          option = Hash[*args]
          option[:repo] = repo
        end

        config = Git.config

        account = option.fetch(:account, config[:login])
        repo    = option[:repo]
        file    = option[:file]
        branch  = option.fetch(:branch, 'master')

        scheme  = option.fetch(:scheme, :http).to_sym
        unless file.nil? || file.empty?
          scheme = :http
        end

        url = FMT_URL[scheme] % [account, repo]
        unless file.nil? || file.empty?
          url + FMT_FILE % [branch, file]
        end

        url
      end
    end
  end
end

module Octopussy
  class Client
    def self.authorized(*args)
      args.unshift X::Util::Git.config if args.size == 0
      self.new *args
    end
  end
end
