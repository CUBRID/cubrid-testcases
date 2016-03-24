-- date
--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = ko_KR';
select 'to_date( , DAY )';
SELECT TO_DATE('2011-05-01 일요일', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-02 월요일', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-03 화요일', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-04 수요일', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-05 목요일', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-06 금요일', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-07 토요일', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
SELECT TO_DATE('2011-05-01 일요일', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-02 월요일', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-03 화요일', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-04 수요일', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-05 목요일', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-06 금요일', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-07 토요일', 'yyyy-MM-DD day');

select 'to_date( , DY )';
SELECT TO_DATE('2011-05-01 일', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-02 월', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-03 화', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-04 수', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-05 목', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-06 금', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-07 토', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
SELECT TO_DATE('2011-05-01 일', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-02 월', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-03 화', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-04 수', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-05 목', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-06 금', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-07 토', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
SELECT TO_DATE('2010-01 1월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 2월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 3월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 4월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 5월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 6월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 7월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 8월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 9월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 10월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 11월', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 12월', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
SELECT TO_DATE('2010-01 1월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 2월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 3월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 4월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 5월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 6월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 7월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 8월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 9월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 10월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 11월', 'yyyy-dd month');
SELECT TO_DATE('2010-01 12월', 'yyyy-dd month');


select 'to_date( ,  MON)';
SELECT TO_DATE('2010-01 1월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 2월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 3월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 4월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 5월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 6월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 7월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 8월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 9월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 10월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 11월', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 12월', 'yyyy-dd MON');

select 'to_date( ,  mon)';
SELECT TO_DATE('2010-01 1월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 2월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 3월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 4월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 5월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 6월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 7월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 8월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 9월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 10월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 11월', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 12월', 'yyyy-dd mon');

select 'to_date( ,  Month)';
SELECT TO_DATE('2010-01 1월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 2월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 3월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 4월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 5월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 6월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 7월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 8월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 9월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 10월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 11월', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 12월', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
SELECT TO_DATE('2010-01 1월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 2월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 3월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 4월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 5월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 6월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 7월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 8월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 9월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 10월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 11월', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 12월', 'yyyy-dd Mon');

-- text
SELECT TO_DATE('2010-01 te월t 11월', 'yyyy-dd "te월t" Mon');

SELECT TO_DATE('2010-01 te월t 11월', 'yyyy-dd "tE월t" Mon');

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

