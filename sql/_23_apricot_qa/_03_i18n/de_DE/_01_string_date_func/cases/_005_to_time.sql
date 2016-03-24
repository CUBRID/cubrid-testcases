--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = de_DE';
set system parameters 'intl_date_lang = de_DE';
-- TO_TIME

-- text
SELECT TO_TIME('10:11:12 teÄt nachm.', 'HH:MI:SS "teät" PM');

SELECT TO_DATE('2010-01 teät Nov', 'yyyy-dd "teÄt" Mon');

select 'TO_TIME( ,  PM)';
SELECT TO_TIME('10:11:12 Nachm.', 'HH:MI:SS PM');
SELECT TO_TIME('10:11:12 Vorm.', 'HH:MI:SS AM');
SELECT TO_TIME('10:11:12 Nachm.', 'HH:MI:SS P.M.');
SELECT TO_TIME('10:11:12 Vorm.', 'HH:MI:SS A.M.');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
