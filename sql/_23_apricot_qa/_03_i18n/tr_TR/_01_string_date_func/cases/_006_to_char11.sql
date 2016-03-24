--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
select 'TO_CHAR(TIME, AM/PM)';
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS AM' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS PM' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS am' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS pm' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS Am' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS Pm' , ' ko_KR');

--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS a.m.' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS p.m.' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS A.M.' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS A.M.' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS A.m.' , ' ko_KR');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS A.m.' , ' ko_KR');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

