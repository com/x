" Turkish-Q keyboard spesific.

if &enc != 'utf-8'
	finish
endif

" ------------------------------------------------------------------------------
" Map Turkish keys
" ------------------------------------------------------------------------------

" ı → Dotless i
" 'q' kaydedicisindeki içeriği çalıştır (makro kayıtlarında yararlı)
if mapcheck("<Char-305>") == "" | noremap <Char-305> @q | endif

" ü → udiaeresis
" Kursördeki anahtar kelimeye atla
if mapcheck("<Char-252>") == "" | noremap <Char-252> <c-]> | endif
" Ü → Udiaeresis
" Cscope'ta kursördeki kelimeyi ara
if mapcheck("<Char-220>") == "" | noremap <Char-220> :cs find s <c-r>=expand("<cword>")<cr><cr> | endif
" ö → odiaeresis
" `
if mapcheck("<Char-246>") == "" | noremap <Char-246> ` | endif
" Ö → Odiaeresis
" '
if mapcheck("<Char-214>") == "" | noremap <Char-214> ' | endif
" ç → ccedilla
" ``  Son atlamadan önceki konuma dön
if mapcheck("<Char-231>") == "" | noremap <Char-231> `` | endif
" Ç → Ccedilla
" '' Son atlamadan önceki satıra dön
if mapcheck("<Char-199>") == "" | noremap <Char-199> '' | endif
" ğ → gbreve
" }
if mapcheck("<Char-287>") == "" | noremap <Char-287> } | vnoremap <Char-287> } | endif
" Ğ → Gbreve
" }
if mapcheck("<Char-286>") == "" | noremap <Char-286> { | vnoremap <Char-286> { | endif
" ş → scedilla
" Kursörün altındaki kelimeyi bul/değiştir
if mapcheck("<Char-351>") == ""
	noremap <Char-350> :%s/<c-r>=expand("<cword>")<cr>//gc<left><left><left>
	vnoremap <Char-350> :s/<c-r>=expand("<cword>")<cr>//gc<left><left><left>
endif
" Ş → Scedilla
" Bul/değiştir istemine geç
if mapcheck("<Char-350>") == ""
	noremap <Char-351> :%s///gc<left><left><left><left>
	vnoremap <Char-351> :s///gc<left><left><left><left>
endif

" ------------------------------------------------------------------------------
" Abbreviations for frequently occured Turkish typos
" ------------------------------------------------------------------------------

iab arzederim arz ederim
iab aşkolsun aşk olsun
iab bilimum bilumum
iab biribiri birbiri
iab biribirine birbirine
iab birşey bir şey
iab arttırılma artırılma
iab arttırmak artırmak
iab arttırır artırır
iab bugünki bugünkü
iab büyültmek büyütmek
iab dedektif detektif
iab dinazor dinozor
iab döküman doküman
iab ençok en çok
iab entellektüel entelektüel
iab herbir her bir
iab hergün her gün
iab Hergün Her gün
iab herkez herkes
iab herşey her şey
iab herzaman her zaman
iab hoşçakal hoşça kal
iab itibariyla itibarıyla
iab itibariyle itibarıyla
iab ıstırap ıztırap
iab kanepe kanape
iab kilot külot
iab kolleksiyon koleksiyon
iab küpür kupür
iab küsür küsur
iab labaratuar lâboratuvar
iab labaratuvar lâboratuvar
iab laboratuar lâboratuvar
iab laborotuar lâboratuvar
iab makina makine
iab malesef maalesef
iab mazallah maazallah
iab mundar murdar
iab müsade müsaade
iab orjinal orijinal
iab pantalon pantolon
iab potbori potpuri
iab raslamak rastlamak
iab rötüş rötuş
iab Rumen Romen
iab silüet siluet
iab süpriz sürpriz
iab şovenizm şovinizm
iab şöför şoför
iab taktir takdir
iab teror terör
iab terörist terorist
iab terörizm terorizm
iab tişort tişört
iab transistör transistor
iab tranzistor transistor
iab tranzistör transistor
iab ultimatom ültimatom
iab uluslararası uluslar arası
iab ünvan unvan
iab virtüöz virtüoz
iab yada ya da
iab yalnış yanlış
iab yanlız yalnız
iab zerafet zarafet
