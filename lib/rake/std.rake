# encoding: utf-8

namespace :std do
  desc "Standart temizlik"
  task :clean do
    purged = []
    FileList["**/*", "**/.*"].each do |path|
      # sıfır boyutlu dosyalar
      purged << path if FileTest.size(path) == 0
    end
    rm_rf purged unless purged.empty?
  end

  desc "Daha fazla temizlik"
  task :clobber => :clean
end
