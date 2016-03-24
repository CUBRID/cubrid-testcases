-- TO_TIME
--+ holdcas on;
set names iso88591;
set system parameters 'intl_date_lang = ko_KR';

-- text
SELECT TO_TIME('10:11:12 te후t ohu', 'HH:MI:SS "te후t" PM');

SELECT TO_DATE('2010-01 tE후t 11wol', 'yyyy-dd "te후t" Mon');

select 'TO_TIME( ,  PM)';
SELECT TO_TIME('10:11:12 ohu', 'HH:MI:SS PM');
SELECT TO_TIME('10:11:12 ojeon', 'HH:MI:SS AM');
SELECT TO_TIME('10:11:12 ohu', 'HH:MI:SS P.M.');
SELECT TO_TIME('10:11:12 ojeon', 'HH:MI:SS A.M.');

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
