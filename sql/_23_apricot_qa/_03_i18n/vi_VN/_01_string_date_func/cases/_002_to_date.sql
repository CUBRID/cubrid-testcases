--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = vi_VN';
-- date
select 'to_date( , DAY )';
SELECT TO_DATE('2011-05-01 CHỦ NHẬT', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-02 THỨ HAI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-03 THỨ BA', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-04 THỨ TƯ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-05 THỨ NĂM', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-06 THỨ SÁU', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-07 THỨ BẢY', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
SELECT TO_DATE('2011-05-01 chủ nhật', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-02 thứ hai', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-03 Thứ ba', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-04 thứ tư', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-05 thứ năm', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-06 thứ sáu', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-07 thứ bảy', 'yyyy-MM-DD day');

select 'to_date( , DY )';
SELECT TO_DATE('2011-05-01 CN', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-02 TH 2', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-03 TH 3', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-04 TH 4', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-05 Th 5', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-06 Th 6', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-07 Th 7', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
SELECT TO_DATE('2011-05-01 cn', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-02 th 2', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-03 th 3', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-04 th 4', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-05 th 5', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-06 th 6', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-07 th 7', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
SELECT TO_DATE('2010-01 THÁNG MỘT', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG HAI', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG BA', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG TƯ', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG NĂM', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG SÁU', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG BẢY', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG TÁM', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG CHÍN', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG MƯỜI', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG MƯỜI MỘT', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 THÁNG MƯỜI HAI', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
SELECT TO_DATE('2010-01 tháng một', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng hai', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng ba', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng tư', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng năm', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng sáu', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng bảy', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng tám', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng chín', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng mười', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng mười một', 'yyyy-dd month');
SELECT TO_DATE('2010-01 tháng mười hai', 'yyyy-dd month');


select 'to_date( ,  MON)';
SELECT TO_DATE('2010-01 THG 1', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 2', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 3', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 4', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 5', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 6', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 7', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 8', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 9', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 10', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 11', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 THG 12', 'yyyy-dd MON');

select 'to_date( ,  mon)';
SELECT TO_DATE('2010-01 thg 1', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 2', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 3', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 4', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 5', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 6', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 7', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 8', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 9', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 10', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 11', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 thg 12', 'yyyy-dd mon');

select 'to_date( ,  Month)';
SELECT TO_DATE('2010-01 tháng một', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng hai', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng ba', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng tư', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng năm', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng sáu', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng bảy', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng tám', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng chín', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng mười', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng mười một', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 tháng mười hai', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
SELECT TO_DATE('2010-01 thg 1', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 2', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 3', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 4', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 5', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 6', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 7', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 8', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 9', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 10', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 11', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 thg 12', 'yyyy-dd Mon');

-- text
SELECT TO_DATE('2010-01 teát thg 11', 'yyyy-dd "teÁt" Mon');

SELECT TO_DATE('2010-01 teÁt thg 11', 'yyyy-dd "teát" Mon');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;


