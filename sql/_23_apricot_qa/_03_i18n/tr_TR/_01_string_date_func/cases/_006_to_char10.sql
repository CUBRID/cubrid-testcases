--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
select 'TO_CHAR(TIME, AM/PM)';
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS AM' , 'en_US');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS PM' , 'en_US');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS am' , 'en_US');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS pm' , 'en_US');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS Am' , 'en_US');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS Pm' , 'en_US');

--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS a.m.' , 'en_US');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS p.m.' , 'en_US');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS A.M.' , 'en_US');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS A.M.' , 'en_US');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS A.m.' , 'en_US');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS A.m.' , 'en_US');

set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;