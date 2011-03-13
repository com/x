" Set K&R style options.
fun! s:c_style_kr(...)
	let sw = (a:0 > 0) ? a:1 : &sw
	setl ts=8 noet nolbr sta noic noai nosi cin sm
	setl cino=>s,e0,n0,f0,{0,}0,^0,:0,=s,ps,t0,c3,+s,(2s,us,gs,hs,(0,)100,*100
	setl fo=croq2 com=sr:/*,mb:*,el:*/,b:// cinw=if,else,while,do,for,case,switch
	exe 'setl sts='. sw . ' sw=' . sw
endfun
com! -nargs=* StyleKR call s:c_style_kr(<args>)

" Set GNU style options.
fun! s:c_style_gnu()
	setl ts=8 sts=2 sw=2 tw=78 et nolbr sta noic noai nosi cin sm
	setl cino=>2s,n-s,f0,{s,}0,^-s,t0,:s,p5
	setl fo=croq2 com=sr:/*,mb:\ ,el:*/,b:// cinw=if,else,while,do,for,switch
endfun
com! -nargs=0 StyleGNU call s:c_style_gnu()

" Set BSDish KNF (Kernel Normal Form) style options.
fun! s:c_style_knf(...)
	let sw = (a:0 > 0) ? a:1 : &sw
	setl ts=8 noet nolbr sta noic noai nosi cin sm
	setl cino=>s,e0,n0,f0,{0,}0,^0,:4,=4,p2,t2,+4,(4,)100,*100,gs,hs
	setl fo=croq2 com=sr:/*,mb:*,el:*/,b:// cinw=if,else,while,do,for,case,switch
	exe 'setl sts='. sw . ' sw=' . sw
endfun
com! -nargs=* StyleKNF call s:c_style_knf(<args>)

" TODO: Whitesmiths and others.
