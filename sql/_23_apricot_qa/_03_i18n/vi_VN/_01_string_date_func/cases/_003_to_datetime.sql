--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = vi_VN';
-- to_datetime
select 'TO_DATETIME( , DAY   )';
SELECT TO_DATETIME('2011-05-01 CHỦ NHẬT 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-02 THỨ HAI 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-03 THỨ BA 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-04 THỨ TƯ 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-05 THỨ NĂM 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-06 THỨ SÁU 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-07 THỨ BẢY 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');

select 'TO_DATETIME( ,  day )';
SELECT TO_DATETIME('2011-05-01 chủ nhật', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-02 thứ hai', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-03 Thứ ba', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-04 thứ tư', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-05 thứ năm', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-06 thứ sáu', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-07 thứ bảy', 'yyyy-MM-DD day');

select 'TO_DATETIME( , DY )';
SELECT TO_DATETIME('2011-05-01 CN', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-02 TH 2', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-03 TH 3', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-04 TH 4', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-05 Th 5', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-06 Th 6', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-07 Th 7', 'yyyy-MM-DD DY');

select 'TO_DATETIME( ,  dy )';
SELECT TO_DATETIME('2011-05-01 cn', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-02 th 2', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-03 th 3', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-04 th 4', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-05 th 5', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-06 th 6', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-07 th 7', 'yyyy-MM-DD dy');

-- month
select 'TO_DATETIME( ,  MONTH)';
SELECT TO_DATETIME('2010-01 THÁNG MỘT', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG HAI', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG BA', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG TƯ', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG NĂM', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG SÁU', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG BẢY', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG TÁM', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG CHÍN', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG MƯỜI', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG MƯỜI MỘT', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 THÁNG MƯỜI HAI', 'yyyy-dd MONTH');

select 'TO_DATETIME( ,  month)';
SELECT TO_DATETIME('2010-01 tháng một', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng hai', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng ba', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng tư', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng năm', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng sáu', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng bảy', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng tám', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng chín', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng mười', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng mười một', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 tháng mười hai', 'yyyy-dd month');


select 'TO_DATETIME( ,  MON)';
SELECT TO_DATETIME('2010-01 THG 1', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 2', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 3', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 4', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 5', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 6', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 7', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 8', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 9', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 10', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 11', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 THG 12', 'yyyy-dd MON');

select 'TO_DATETIME( ,  mon)';
SELECT TO_DATETIME('2010-01 thg 1', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 2', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 3', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 4', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 5', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 6', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 7', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 8', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 9', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 10', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 11', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 thg 12', 'yyyy-dd mon');

select 'TO_DATETIME( ,  Month)';
SELECT TO_DATETIME('2010-01 tháng một', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng hai', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng ba', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng tư', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng năm', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng sáu', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng bảy', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng tám', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng chín', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng mười', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng mười một', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 tháng mười hai', 'yyyy-dd Month');

select 'TO_DATETIME( ,  Mon)';
SELECT TO_DATETIME('2010-01 thg 1', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 2', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 3', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 4', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 5', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 6', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 7', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 8', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 9', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 10', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 11', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 thg 12', 'yyyy-dd Mon');

-- text
SELECT TO_DATETIME('2010-01 teÁt thg 11', 'yyyy-dd "teát" Mon');

SELECT TO_DATE('2010-01 teát thg 11', 'yyyy-dd "teÁt" Mon');

select 'TO_DATETIME( ,  PM)';
SELECT TO_DATETIME('2011-05-01 CHỦ NHẬT 10:11:12 CH', 'yyyy-MM-DD DAY HH:MI:SS PM');
SELECT TO_DATETIME('2011-05-01 CHỦ NHẬT 10:11:12 SA', 'yyyy-MM-DD DAY HH:MI:SS AM');
SELECT TO_DATETIME('2011-05-01 CHỦ NHẬT 10:11:12 CH', 'yyyy-MM-DD DAY HH:MI:SS P.M.');
SELECT TO_DATETIME('2011-05-01 CHỦ NHẬT 10:11:12 SA', 'yyyy-MM-DD DAY HH:MI:SS A.M.');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

