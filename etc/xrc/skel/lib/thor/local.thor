# encoding: utf-8

# Kişisel thor görevleri (örnek kod).

require 'x/thor'

class Local < Thor
  default_task :test
  desc "test", "Test"
  def test
    say color("Çeşitli yardımcı işlevler", :headline)
    # durum iletileri
    say_status "durum", "durum iletisi"
    # tablo bas, dikkat!  sütün sayıları aynı olmalı
    print_table([["foo", "bar", "baz"], [2, 7, 9]], :ident => 8)
    # açık evet iste
    say (yes? "devam?", :yellow) ? "devam" : "tamam"
    # öntanımlı evet
    say (yes_default? "devam?", :yellow) ? "devam" : "tamam"
    # girdi al
    say ask("Adınız?", :cyan)
    # öntanımlı bir değerle girdi al
    say ask_default "bir şey gir [öntanımlı]"
    # geçici dizinde bir eylem gerçekleştir, çıkışta geçici dizin silinir
    in_tempdir { |t| say "geçici dizin: #{t}" }
    # gizli girdi al
    say whisper("Parola? ") { |q| q.validate = /[0-9]/ }
    # dur
    pause "Devam etmek için bir tuşa basın..."
    # basit menü
    choose do |menu|
      menu.default = :ruby
      menu.prompt = color(
        'Tercih ettiğiniz programlama dili? ', :headline
      ) + '[' + color("#{menu.default}", :special) + ']'
      menu.choice(:ruby) { |ans| say("#{ans.capitalize} mükemmel seçim!") }
      menu.choices(:python, :perl) { say("Buralardan değilsiniz, öyle mi?") }
    end
  end
  desc "daha", "Daha fazla test"
  def daha
    say color("Grit testi", :headline)
    g = Grit::Repo.new(ENV['HOME'])
    puts g.commits
    say color("Octopussy testi", :headline)
    c = Octopussy.user '00010011'
    puts c.name
    # Yetkilendirme gerektiren işlemler
    # c = Octopussy::Client::authorized
    # c.create(:name => "t")
    # p c.login
  end
end
