set names utf8 collate utf8_tr_cs;
set system parameters 'intl_date_lang=tr_tr';
select date_format(date'12/27/2012','%d.%M.%Y');
select upper('27.Aralık.2012');
select upper(date_format(date'12/27/2012','%d.%M.%Y'));
select upper(to_char(date '2012-3-1', _utf8'dy,day,mon', 'de_DE'));
set names iso88591;

set system parameters 'intl_date_lang=en_US';