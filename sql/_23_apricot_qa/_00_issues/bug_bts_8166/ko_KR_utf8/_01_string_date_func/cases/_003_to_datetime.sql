-- to_datetime
--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = ko_KR';
select 'TO_DATETIME( , DAY   )';
SELECT TO_DATETIME('2011-05-01 일요일 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-02 월요일 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-03 화요일 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-04 수요일 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-05 목요일 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-06 금요일 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-07 토요일 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');

select 'TO_DATETIME( ,  day )';
SELECT TO_DATETIME('2011-05-01 일요일', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-02 월요일', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-03 화요일', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-04 수요일', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-05 목요일', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-06 금요일', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-07 토요일', 'yyyy-MM-DD day');

select 'TO_DATETIME( , DY )';
SELECT TO_DATETIME('2011-05-01 일', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-02 월', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-03 화', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-04 수', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-05 목', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-06 금', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-07 토', 'yyyy-MM-DD DY');

select 'TO_DATETIME( ,  dy )';
SELECT TO_DATETIME('2011-05-01 일', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-02 월', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-03 화', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-04 수', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-05 목', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-06 금', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-07 토', 'yyyy-MM-DD dy');

-- month
select 'TO_DATETIME( ,  MONTH)';
SELECT TO_DATETIME('2010-01 1월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 2월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 3월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 4월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 5월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 6월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 7월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 8월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 9월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 10월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 11월', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 12월', 'yyyy-dd MONTH');

select 'TO_DATETIME( ,  month)';
SELECT TO_DATETIME('2010-01 1월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 2월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 3월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 4월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 5월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 6월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 7월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 8월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 9월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 10월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 11월', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 12월', 'yyyy-dd month');


select 'TO_DATETIME( ,  MON)';
SELECT TO_DATETIME('2010-01 1월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 2월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 3월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 4월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 5월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 6월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 7월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 8월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 9월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 10월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 11월', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 12월', 'yyyy-dd MON');

select 'TO_DATETIME( ,  mon)';
SELECT TO_DATETIME('2010-01 1월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 2월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 3월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 4월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 5월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 6월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 7월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 8월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 9월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 10월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 11월', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 12월', 'yyyy-dd mon');

select 'TO_DATETIME( ,  Month)';
SELECT TO_DATETIME('2010-01 1월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 2월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 3월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 4월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 5월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 6월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 7월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 8월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 9월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 10월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 11월', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 12월', 'yyyy-dd Month');

select 'TO_DATETIME( ,  Mon)';
SELECT TO_DATETIME('2010-01 1월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 2월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 3월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 4월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 5월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 6월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 7월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 8월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 9월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 10월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 11월', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 12월', 'yyyy-dd Mon');

-- text
SELECT TO_DATETIME('2010-01 te월t 11월', 'yyyy-dd "te월t" Mon');

SELECT TO_DATE('2010-01 te월t 11월', 'yyyy-dd "tE월t" Mon');

select 'TO_DATETIME( ,  PM)';
SELECT TO_DATETIME('2011-05-01 일요일 10:11:12 오후', 'yyyy-MM-DD DAY HH:MI:SS PM');
SELECT TO_DATETIME('2011-05-01 일요일 10:11:12 오전', 'yyyy-MM-DD DAY HH:MI:SS AM');
SELECT TO_DATETIME('2011-05-01 일요일 10:11:12 오후', 'yyyy-MM-DD DAY HH:MI:SS P.M.');
SELECT TO_DATETIME('2011-05-01 일요일 10:11:12 오전', 'yyyy-MM-DD DAY HH:MI:SS A.M.');

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
