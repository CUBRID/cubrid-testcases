-- TIME_FORMAT
--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = tr_TR';

SELECT TIME_FORMAT('22:23:24', '%l:%i%s %r');

SELECT TIME_FORMAT('10:23:24', '%l:%i%s %r');

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
