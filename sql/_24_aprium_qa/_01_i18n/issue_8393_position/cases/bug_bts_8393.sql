set names utf8;
select position('b' in 'aBc');
select position('b' in 'aBbc');                                                                                                
set names utf8 collate utf8_en_ci;
select position('b' in 'aBc');
select position('b' in 'aBbc');

set names utf8;
select position('b' in 'aBc' collate utf8_gen_ai_ci);
select position('b' collate utf8_gen_ai_ci in 'aBbc');

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';

set names iso88591;
select position('Ä' in 'äBc');
select position('Ä' in 'äBbc');

set names utf8;
select position('Ä' in 'aäc' collate utf8_de_exp_ai_ci);
select position('Ä' collate utf8_de_exp_ai_ci in 'aäbc');

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

set names utf8 collate utf8_ja_exp_cbm;
select position('ぁー' in 'aBｧー');
set names utf8;
select position('ｧー' in 'ぁーBbc');

set names iso88591;
