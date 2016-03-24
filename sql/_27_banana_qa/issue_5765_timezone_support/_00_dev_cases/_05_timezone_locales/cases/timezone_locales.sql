set names utf8;

--German language
set system parameters 'intl_date_lang=de_DE';

--format is HH24:MI:SS DD.MM.YYYY TZR
select to_timestamp_tz('23:59:59 12.11.2001 Europe/Vienna');

--format is HH24:MI:SS.FF DD.MM.YYYY TZR
select to_datetime_tz('23:59:59.00 12.11.2001 Asia/Seoul');

--Spanish language
set system parameters 'intl_date_lang=es_ES';

--format is HH24:MI:SS DD/MM/YYYY TZR
select to_timestamp_tz('23:59:59 12/11/2001 Europe/Vienna');

--format is HH24:MI:SS.FF DD/MM/YYYY TZR
select to_datetime_tz('23:59:59.00 12/11/2001 Asia/Seoul');

--French language
set system parameters 'intl_date_lang=fr_FR';

--format is HH24:MI:SS DD/MM/YYYY TZR
select to_timestamp_tz('23:59:59 12/11/2001 Europe/Vienna');

--format is HH24:MI:SS.FF DD/MM/YYYY TZR
select to_datetime_tz('23:59:59.00 12/11/2001 Asia/Seoul');

--Italian language
set system parameters 'intl_date_lang=it_IT';

--format is HH24:MI:SS DD/MM/YYYY TZR
select to_timestamp_tz('23:59:59 12/11/2001 Europe/Vienna');

--format is HH24:MI:SS.FF DD/MM/YYYY TZR
select to_datetime_tz('23:59:59.00 12/11/2001 Asia/Seoul');

--Japanese language
set system parameters 'intl_date_lang=ja_JP';

--format is HH24:MI:SS DD/MM/YYYY TZR
select to_timestamp_tz('23:59:59 12/11/2001 Europe/Vienna');

--format is HH24:MI:SS.FF DD/MM/YYYY TZR
select to_datetime_tz('23:59:59.00 12/11/2001 Asia/Seoul');

--Khmer - Cambodia
set system parameters 'intl_date_lang=km_KH';

--format is HH24:MI:SS DD/MM/YYYY TZR
select to_timestamp_tz('23:59:59 12/11/2001 Europe/Vienna');

--format is HH24:MI:SS.FF DD/MM/YYYY TZR
select to_datetime_tz('23:59:59.00 12/11/2001 Asia/Seoul');

--Korean language
set system parameters 'intl_date_lang=ko_KR';

--format is HH24:MI:SS YYYY. MM. DD TZR
select to_timestamp_tz('23:59:59 2001. 11. 12 Europe/Vienna');

--format is HH24:MI:SS.FF YYYY. MM. DD TZR
select to_datetime_tz('23:59:59.00 2001. 11. 12 Europe/Vienna');

--Romanian language
set system parameters 'intl_date_lang=ro_RO';

--format is HH24:MI:SS DD.MM.YYYY TZR
select to_timestamp_tz('23:59:59 12.11.2001 Europe/Vienna');

--format is HH24:MI:SS.FF DD.MM.YYYY TZR
select to_datetime_tz('23:59:59.00 12.11.2001 Europe/Vienna');

--Turkish language
set system parameters 'intl_date_lang=tr_TR';

--format is HH24:MI:SS DD.MM.YYYY TZR
select to_timestamp_tz('23:59:59 12.11.2001 Europe/Vienna');

--format is HH24:MI:SS.FF DD.MM.YYYY TZR
select to_datetime_tz('23:59:59.00 12.11.2001 Europe/Vienna');

--Vietnamese language
set system parameters 'intl_date_lang=vi_VN';

--format is HH24:MI:SS DD/MM/YYYY TZR
select to_timestamp_tz('23:59:59 12/11/2001 Europe/Vienna');

--format is HH24:MI:SS.FF DD/MM/YYYY TZR
select to_datetime_tz('23:59:59.00 12/11/2001 Europe/Vienna');

--Chinese language
set system parameters 'intl_date_lang=zh_CN';

--format is HH24:MI:SS YYYY-MM-DD TZR
select to_timestamp_tz('23:59:59 2001-12-11 Europe/Vienna');

--format is HH24:MI:SS.FF YYYY-MM-DD TZR
select to_datetime_tz('23:59:59.00 2001-12-11 Europe/Vienna');

set system parameters 'intl_date_lang=en_US';

set names iso88591;
