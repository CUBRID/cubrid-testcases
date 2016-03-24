-- TO_CHAR (number)
--+ holdcas on;
set names iso88591;
set system parameters 'intl_number_lang = tr_TR';

select to_char (123456.789123);

select to_char (123456.789123,'999999,999999');  

set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

