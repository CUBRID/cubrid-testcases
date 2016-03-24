-- TO_TIME

-- text
--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = zh_CN';
SELECT TO_TIME('10:11:12 测试 pm', 'HH:MI:SS "teıt" PM');

SELECT TO_DATE('2010-01 测试 十一月', 'yyyy-dd "teSt" Mon');

select 'TO_TIME( ,  PM)';
SELECT TO_TIME('10:11:12 下午', 'HH:MI:SS 下午');
SELECT TO_TIME('10:11:12 上午', 'HH:MI:SS AM');
SELECT TO_TIME('10:11:12 下.午.', 'HH:MI:SS 下.午.');
SELECT TO_TIME('10:11:12 上.午.', 'HH:MI:SS A.M.');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

