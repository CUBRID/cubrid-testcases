set names utf8;
select find_in_set('b', 'a,B,c');
select find_in_set('b', 'a,B,b,c');                                                                                                  
set names utf8 collate utf8_en_ci;
select find_in_set('b', 'a,B,c');
select find_in_set('b', 'a,B,b,c');

set names utf8;
select find_in_set('b', 'a,B,c' collate utf8_gen_ai_ci);
select find_in_set('b' collate utf8_gen_ai_ci, 'a,B,b,c');

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';

set names iso88591;
select find_in_set('Ä', 'ä,B,c');
select find_in_set('Ä', 'ä,B,b,c');

set names utf8;
select find_in_set('Ä', 'a,ä,c' collate utf8_de_exp_ai_ci);
select find_in_set('Ä' collate utf8_de_exp_ai_ci, 'a,ä,b,c');

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

set names utf8 collate utf8_ja_exp_cbm;
select find_in_set('ぁー', 'a,B,ｧー');
set nameS utf8;
select find_in_set('ｧー', 'ぁー,B,b,c');

set names iso88591;
