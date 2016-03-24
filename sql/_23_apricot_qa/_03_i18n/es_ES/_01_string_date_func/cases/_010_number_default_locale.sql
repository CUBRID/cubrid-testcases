--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = es_ES';
set system parameters 'intl_date_lang = es_ES';

-- string - date function with 'use_locale_number_format' system parameter


select to_char (123456.789123);

select to_number ('123456.789123');

select to_number ('123.456,789','999.999,999');

select to_number ('123,456.789','999,999.999');




select to_char (123456.789123);

select to_number ('123456.789123');

select to_number ('123.456,789','999.999,999');

select to_number ('123,456.789','999,999.999');


set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;