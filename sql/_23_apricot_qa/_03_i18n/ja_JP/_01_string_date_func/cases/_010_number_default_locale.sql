-- string - date function with 'use_locale_number_format' system parameter
--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = ja_JP';
set system parameters 'intl_date_lang = ja_JP';

select to_char (123456.789123);

select to_number ('123456.789123');

select to_number ('123.456,789','999.999,999');

select to_number ('123,456.789','999,999.999');




select to_char (123456.789123);

select to_number ('123456.789123');

select to_number ('123.456,789','999.999,999');

select to_number ('123,456.789','999,999.999');


set system parameters 'intl_date_lang = ja_JP';
set system parameters 'intl_number_lang = ja_JP';
set names iso88591;
commit;
--+ holdcas off;