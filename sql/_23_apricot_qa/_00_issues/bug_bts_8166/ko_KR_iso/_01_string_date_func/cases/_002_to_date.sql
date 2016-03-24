-- date
--+ holdcas on;
set names iso88591;
set system parameters 'intl_date_lang = ko_KR';
select 'to_date( , DAY )';
SELECT TO_DATE('2011-05-01 Iryoil', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-02 Woryoil', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-03 Hwayoil', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-04 Suyoil', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-05 Mogyoil', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-06 Geumyoil', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-07 Toyoil', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
SELECT TO_DATE('2011-05-01 Iryoil', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-02 Woryoil', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-03 Hwayoil', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-04 Suyoil', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-05 Mogyoil', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-06 Geumyoil', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-07 Toyoil', 'yyyy-MM-DD day');

select 'to_date( , DY )';
SELECT TO_DATE('2011-05-01 Il', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-02 Wol', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-03 Hwa', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-04 Su', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-05 Mok', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-06 Geum', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-07 To', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
SELECT TO_DATE('2011-05-01 Il', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-02 Wol', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-03 Hwa', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-04 Su', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-05 Mok', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-06 Geum', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-07 To', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
SELECT TO_DATE('2010-01 1wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 2wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 3wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 4wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 5wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 6wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 7wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 8wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 9wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 10wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 11wol', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 12wol', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
SELECT TO_DATE('2010-01 1wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 2wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 3wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 4wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 5wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 6wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 7wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 8wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 9wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 10wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 11wol', 'yyyy-dd month');
SELECT TO_DATE('2010-01 12wol', 'yyyy-dd month');


select 'to_date( ,  MON)';
SELECT TO_DATE('2010-01 1wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 2wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 3wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 4wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 5wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 6wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 7wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 8wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 9wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 10wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 11wol', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 12wol', 'yyyy-dd MON');

select 'to_date( ,  mon)';
SELECT TO_DATE('2010-01 1wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 2wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 3wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 4wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 5wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 6wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 7wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 8wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 9wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 10wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 11wol', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 12wol', 'yyyy-dd mon');

select 'to_date( ,  Month)';
SELECT TO_DATE('2010-01 1wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 2wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 3wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 4wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 5wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 6wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 7wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 8wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 9wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 10wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 11wol', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 12wol', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
SELECT TO_DATE('2010-01 1wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 2wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 3wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 4wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 5wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 6wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 7wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 8wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 9wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 10wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 11wol', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 12wol', 'yyyy-dd Mon');

-- text
SELECT TO_DATE('2010-01 teWolt 11wol', 'yyyy-dd "teWolt" Mon');

SELECT TO_DATE('2010-01 teWolt 11wol', 'yyyy-dd "tEWolt" Mon');

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

