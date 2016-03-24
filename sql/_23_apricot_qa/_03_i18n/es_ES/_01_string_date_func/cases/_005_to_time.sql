--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = es_ES';
-- TO_TIME

-- text
SELECT TO_TIME('10:11:12 teÌt pm', 'HH:MI:SS "teìt" PM');

SELECT TO_DATE('2010-01 teìt Nov', 'yyyy-dd "teÌt" Mon');

select 'TO_TIME( ,  PM)';
SELECT TO_TIME('10:11:12 PM', 'HH:MI:SS PM');
SELECT TO_TIME('10:11:12 AM', 'HH:MI:SS AM');
SELECT TO_TIME('10:11:12 P.M.', 'HH:MI:SS P.M.');
SELECT TO_TIME('10:11:12 A.M.', 'HH:MI:SS A.M.');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

