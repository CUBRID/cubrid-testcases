--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = km_KH';
-- TO_TIME

-- text
SELECT TO_TIME('10:11:12 te១ıt ល្ងាច', 'HH:MI:SS "te១ıt" PM');

SELECT TO_DATE('2010-01 tE១t ១១', 'yyyy-dd "te១t" Mon');

select 'TO_TIME( ,  PM)';
SELECT TO_TIME('10:11:12 ល្ងាច', 'HH:MI:SS PM');
SELECT TO_TIME('10:11:12 ព្រឹក', 'HH:MI:SS AM');
SELECT TO_TIME('10:11:12 ល្ងាច', 'HH:MI:SS P.M.');
SELECT TO_TIME('10:11:12 ព្រឹក', 'HH:MI:SS A.M.');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

