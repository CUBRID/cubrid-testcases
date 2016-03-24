-- to_timestamp
--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = ko_KR';
select 'TO_TIMESTAMP( , DAY   )';
SELECT TO_TIMESTAMP('2011-05-01 일요일 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-02 월요일 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-03 화요일 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-04 수요일 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-05 목요일 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-06 금요일 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-07 토요일 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');

select 'TO_TIMESTAMP( ,  day )';
SELECT TO_TIMESTAMP('2011-05-01 일요일', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-02 월요일', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-03 화요일', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-04 수요일', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-05 목요일', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-06 금요일', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-07 토요일', 'yyyy-MM-DD day');

select 'TO_TIMESTAMP( , DY )';
SELECT TO_TIMESTAMP('2011-05-01 일', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-02 월', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-03 화', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-04 수', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-05 목', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-06 금', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-07 토', 'yyyy-MM-DD DY');

select 'TO_TIMESTAMP( ,  dy )';
SELECT TO_TIMESTAMP('2011-05-01 일', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-02 월', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-03 화', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-04 수', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-05 목', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-06 금', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-07 토', 'yyyy-MM-DD dy');

-- month
select 'TO_TIMESTAMP( ,  MONTH)';
SELECT TO_TIMESTAMP('2010-01 1월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 2월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 3월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 4월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 5월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 6월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 7월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 8월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 9월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 10월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 11월', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 12월', 'yyyy-dd MONTH');

select 'TO_TIMESTAMP( ,  month)';
SELECT TO_TIMESTAMP('2010-01 1월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 2월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 3월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 4월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 5월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 6월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 7월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 8월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 9월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 10월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 11월', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 12월', 'yyyy-dd month');


select 'TO_TIMESTAMP( ,  MON)';
SELECT TO_TIMESTAMP('2010-01 1월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 2월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 3월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 4월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 5월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 6월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 7월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 8월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 9월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 10월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 11월', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 12월', 'yyyy-dd MON');

select 'TO_TIMESTAMP( ,  mon)';
SELECT TO_TIMESTAMP('2010-01 1월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 2월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 3월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 4월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 5월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 6월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 7월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 8월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 9월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 10월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 11월', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 12월', 'yyyy-dd mon');

select 'TO_TIMESTAMP( ,  Month)';
SELECT TO_TIMESTAMP('2010-01 1월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 2월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 3월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 4월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 5월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 6월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 7월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 8월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 9월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 10월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 11월', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 12월', 'yyyy-dd Month');

select 'TO_TIMESTAMP( ,  Mon)';
SELECT TO_TIMESTAMP('2010-01 1월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 2월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 3월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 4월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 5월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 6월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 7월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 8월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 9월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 10월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 11월', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 12월', 'yyyy-dd Mon');

-- text
SELECT TO_TIMESTAMP('2010-01 teı월t 11월', 'yyyy-dd "teı월t" Mon');

SELECT TO_DATE('2010-01 tEı월t 11월', 'yyyy-dd "teı월t" Mon');

select 'TO_TIMESTAMP( ,  PM)';
SELECT TO_TIMESTAMP('2011-05-01 일요일 10:11:12 오후', 'yyyy-MM-DD DAY HH:MI:SS PM');
SELECT TO_TIMESTAMP('2011-05-01 일요일 10:11:12 오전', 'yyyy-MM-DD DAY HH:MI:SS AM');
SELECT TO_TIMESTAMP('2011-05-01 일요일 10:11:12 오후', 'yyyy-MM-DD DAY HH:MI:SS P.M.');
SELECT TO_TIMESTAMP('2011-05-01 일요일 10:11:12 오전', 'yyyy-MM-DD DAY HH:MI:SS A.M.');

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
