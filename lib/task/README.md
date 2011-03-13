Görev dosyaları (Bash, Perl, Ruby, Python, Lua ve hatta "Tiny C Compiler" ile
yorumlama kipinde çalışacak C gibi) herhangi bir betik diliyle yazılan küçük
programlardır.  Dil olarak bash kullanılması halinde 19 kabuk API'sinde yer alan
işlevlerden (herhangi bir kitaplık ithal etmeden) yararlanılabilir.  Ayrıntılar
için lütfen mevcut görevleri inceleyin.

Görev dosyaları `x` sürücü betiğiyle, doğrudan komut satırında ismini belirterek
veya `19/x` menüsünden seçerek çalıştırılır (bu nedenle görev dosyalarının
çalıştırılabilir olması gerekmez ve ayrıca görevler `PATH` içinde değildir).

Kesin hatlarla sınıflayamadığınız görevleri (şablonlardan gelen) `özel-ayarlar`
başlıklı görev dosyasında gerçekleyebilirsiniz.

Görevler aşağıdaki biçimde isimlendirilmiştir:

    <görev kategorisi><görev sırası>-<görev başlığı>

Burada görülen her bir alanın biçim ve anlamı  aşağıda açıklanmıştır.

### Görev Kategorisi

Bir karakterlik bu alanda aşağıdaki rakamlar kullanılmalıdır:

**`0`** 19/x kurulumunda dikkate alınacak görevler

**`1`** Genel amaçlı görevler

**`2`** Sadece yöneticiler için anlamlı görevler

**`7`** Bilinen sorunları çözmeye yönelik dönemsel görevler

**`9`** 19/x deposuyla ilgili görevler

### Görev Sırası

İlgili kategorideki görevlerin tümü (örneğin kurulum sırasında)
çalıştırıldığında görevin hangi sırada çalışacağını bu alan belirler.  Görev
sırası iki basamaktan oluşan bir sayıdır.

### Görev Başlığı

19/x menüsünde ve çalıştırılırken görev tanıtımında kullanılan; tamamen küçük
harflerden oluşan tireyle ayrılmış bir dizi Türkçe kelime.  Bu kelimeler menüde
ve görev tanıtımında ilk harfleri büyük olarak ve tire yerine boşluk
kullanılarak başlık formunda görüntülenecektir.  Bu nedenle bu alanın başlık
olarak bir düşünülen bir cümleden oluşturulması önerilir.  Bu cümle dosya adında
boşluklar tireyle değiştirilerek küçük harflerle yazılacaktır.
