--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = ja_JP';
set system parameters 'intl_date_lang = ja_JP';
-- TO_TIME

-- text
SELECT TO_TIME('10:11:12 te月t 午後', 'HH:MI:SS "tE月t" PM');

SELECT TO_DATE('2010-01 tE月t 11月', 'yyyy-dd "te月t" Mon');

select 'TO_TIME( ,  PM)';
SELECT TO_TIME('10:11:12 午後', 'HH:MI:SS PM');
SELECT TO_TIME('10:11:12 午前', 'HH:MI:SS AM');
SELECT TO_TIME('10:11:12 午後', 'HH:MI:SS P.M.');
SELECT TO_TIME('10:11:12 午前', 'HH:MI:SS A.M.');
set system parameters 'intl_date_lang = ja_JP';
set system parameters 'intl_number_lang = ja_JP';
set names iso88591;
commit;
--+ holdcas off;


