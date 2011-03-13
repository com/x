# encoding: utf-8

if test ?d, '.git'
  namespace :git do
    # Bu bir Git deposu ise görevlere eklemeler yapalım.

    task :clean do
      # git tarafından göz ardı edilen tüm dosyalar
      sh "git clean -fX"
    end

    task :clobber do
      purged = []
      FileList["**/.*"].each do |path|
        next unless test ?f, path
        # tüm izlenmeyen nokta dosyalar
        status = `git ls-files #{path}`.chomp
        purged << path if status.empty?
      end
      rm_rf purged unless purged.empty?
    end

    # Ve yeni görevler ekleyelim.

    desc "Git commit"
    task :commit => :clobber do
      sh "git add ."
      sh "git commit -m 'Auto commit'"
    end
    task :ci => :commit

    desc "Git push"
    task :push => :commit do
      sh "push origin master"
    end
  end
end
