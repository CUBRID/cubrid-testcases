--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';

select 'TO_CHAR(TIME, AM/PM)';
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS AM');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS PM');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS am');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS pm');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS Am');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS Pm');

--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS a.m.');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS p.m.');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS A.M.');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS A.M.');
--test
SELECT TO_CHAR(TIME'10:11:12', 'HH:MI:SS A.m.');
--test
SELECT TO_CHAR(TIME'20:11:12', 'HH:MI:SS A.m.');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
