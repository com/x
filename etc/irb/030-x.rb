# encoding: utf-8

module X
  module Irb
    # TODO
  end
end

include X::Irb

# Alternatif olarak "CodeDiary" var.
Irbtools.remove_library :sketch
Irbtools.welcome_message = "#{RUBY_DESCRIPTION.capitalize}\nBilgi için x-irb(7) kılavuzunu okuyun (veya Tmux altında F1'e basın)."
