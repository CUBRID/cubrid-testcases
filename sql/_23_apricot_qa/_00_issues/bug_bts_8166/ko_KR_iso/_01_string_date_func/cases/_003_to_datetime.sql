-- to_datetime
--+ holdcas on;
set names iso88591;
set system parameters 'intl_date_lang = ko_KR';
select 'TO_DATETIME( , DAY   )';
SELECT TO_DATETIME('2011-05-01 Iryoil 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-02 Woryoil 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-03 Hwayoil 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-04 Suyoil 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-05 Mogyoil 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-06 Geumyoil 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-07 Toyoil 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');

select 'TO_DATETIME( ,  day )';
SELECT TO_DATETIME('2011-05-01 Iryoil', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-02 Woryoil', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-03 Hwayoil', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-04 Suyoil', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-05 Mogyoil', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-06 Geumyoil', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-07 Toyoil', 'yyyy-MM-DD day');

select 'TO_DATETIME( , DY )';
SELECT TO_DATETIME('2011-05-01 Il', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-02 Wol', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-03 Hwa', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-04 Su', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-05 Mok', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-06 Geum', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-07 To', 'yyyy-MM-DD DY');

select 'TO_DATETIME( ,  dy )';
SELECT TO_DATETIME('2011-05-01 Il', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-02 Wol', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-03 Hwa', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-04 Su', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-05 Mok', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-06 Geum', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-07 To', 'yyyy-MM-DD dy');

-- month
select 'TO_DATETIME( ,  MONTH)';
SELECT TO_DATETIME('2010-01 1wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 2wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 3wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 4wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 5wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 6wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 7wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 8wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 9wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 10wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 11wol', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 12wol', 'yyyy-dd MONTH');

select 'TO_DATETIME( ,  month)';
SELECT TO_DATETIME('2010-01 1wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 2wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 3wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 4wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 5wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 6wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 7wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 8wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 9wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 10wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 11wol', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 12wol', 'yyyy-dd month');


select 'TO_DATETIME( ,  MON)';
SELECT TO_DATETIME('2010-01 1wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 2wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 3wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 4wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 5wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 6wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 7wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 8wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 9wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 10wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 11wol', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 12wol', 'yyyy-dd MON');

select 'TO_DATETIME( ,  mon)';
SELECT TO_DATETIME('2010-01 1wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 2wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 3wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 4wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 5wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 6wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 7wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 8wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 9wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 10wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 11wol', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 12wol', 'yyyy-dd mon');

select 'TO_DATETIME( ,  Month)';
SELECT TO_DATETIME('2010-01 1wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 2wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 3wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 4wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 5wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 6wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 7wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 8wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 9wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 10wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 11wol', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 12wol', 'yyyy-dd Month');

select 'TO_DATETIME( ,  Mon)';
SELECT TO_DATETIME('2010-01 1wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 2wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 3wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 4wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 5wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 6wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 7wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 8wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 9wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 10wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 11wol', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 12wol', 'yyyy-dd Mon');

-- text
SELECT TO_DATETIME('2010-01 teWolt 11wol', 'yyyy-dd "teWolt" Mon');

SELECT TO_DATE('2010-01 teWolt 11wol', 'yyyy-dd "tEWolt" Mon');

select 'TO_DATETIME( ,  PM)';
SELECT TO_DATETIME('2011-05-01 Iryoil 10:11:12 ohu', 'yyyy-MM-DD DAY HH:MI:SS PM');
SELECT TO_DATETIME('2011-05-01 Iryoil 10:11:12 ojeon', 'yyyy-MM-DD DAY HH:MI:SS AM');
SELECT TO_DATETIME('2011-05-01 Iryoil 10:11:12 ohu', 'yyyy-MM-DD DAY HH:MI:SS P.M.');
SELECT TO_DATETIME('2011-05-01 Iryoil 10:11:12 ojeon', 'yyyy-MM-DD DAY HH:MI:SS A.M.');

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
