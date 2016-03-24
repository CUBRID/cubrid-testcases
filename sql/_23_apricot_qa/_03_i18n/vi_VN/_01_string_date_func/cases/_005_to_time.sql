--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = vi_VN';
-- TO_TIME

-- text
SELECT TO_TIME('10:11:12 teát CH', 'HH:MI:SS "teÁt" PM');

SELECT TO_DATE('2010-01 teát thg 11', 'yyyy-dd "teát" Mon');

select 'TO_TIME( ,  PM)';
SELECT TO_TIME('10:11:12 CH', 'HH:MI:SS PM');
SELECT TO_TIME('10:11:12 SA', 'HH:MI:SS AM');
SELECT TO_TIME('10:11:12 CH', 'HH:MI:SS P.M.');
SELECT TO_TIME('10:11:12 SA.', 'HH:MI:SS A.M.');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

