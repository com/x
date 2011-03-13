# encoding: utf-8

desc "Öntanımlı temizlik"
task :clean => %w[
	std:clean
	git:clean
]

desc "Öntanımlı derin temizlik"
task :clobber => %w[
	std:clobber
	git:clobber
]
