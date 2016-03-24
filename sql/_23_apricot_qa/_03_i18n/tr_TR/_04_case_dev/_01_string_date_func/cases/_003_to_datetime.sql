--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
-- to_datetime
select 'TO_DATETIME( , DAY   )';
SELECT TO_DATETIME('2011-05-01 PAZAR 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-02 PAZARTESİ 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-03 SALI 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-04 ÇARŞAMBA 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-05 PERŞEMBE 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-06 CUMA 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-07 CUMARTESİ 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');

select 'TO_DATETIME( ,  day )';
SELECT TO_DATETIME('2011-05-01 pazar', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-02 pazartesi', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-03 Salı', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-04 çarşamba', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-05 perşembe', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-06 cuma', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-07 cumartesi', 'yyyy-MM-DD day');

select 'TO_DATETIME( , DY )';
SELECT TO_DATETIME('2011-05-01 PZ', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-02 PT', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-03 SA', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-04 ÇA', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-05 Pe', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-06 Cu', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-07 Ct', 'yyyy-MM-DD DY');

select 'TO_DATETIME( ,  dy )';
SELECT TO_DATETIME('2011-05-01 pz', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-02 pt', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-03 sa', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-04 ça', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-05 pe', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-06 cu', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-07 ct', 'yyyy-MM-DD dy');

-- month
select 'TO_DATETIME( ,  MONTH)';
SELECT TO_DATETIME('2010-01 OCAK', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 ŞUBAT', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 MART', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 NİSAN', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 MAYIS', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 HAZİRAN', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 TEMMUZ', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 AĞUSTOS', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 EYLÜL', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 EKİM', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 KASIM', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 ARALIK', 'yyyy-dd MONTH');

select 'TO_DATETIME( ,  month)';
SELECT TO_DATETIME('2010-01 ocak', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 şubat', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 mart', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 nisan', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 mayıs', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 haziran', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 temmuz', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 ağustos', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 eylül', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 ekim', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 kasım', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 aralık', 'yyyy-dd month');


select 'TO_DATETIME( ,  MON)';
SELECT TO_DATETIME('2010-01 OCK', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 ŞBT', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 MRT', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 NSN', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 MYS', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 HZR', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 TMZ', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 AĞS', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 EYL', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 EKM', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 KSM', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 ARL', 'yyyy-dd MON');

select 'TO_DATETIME( ,  mon)';
SELECT TO_DATETIME('2010-01 ock', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 şbt', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 mrt', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 nsn', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 mys', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 hzr', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 tmz', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 ağs', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 eyl', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 ekm', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 ksm', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 arl', 'yyyy-dd mon');

select 'TO_DATETIME( ,  Month)';
SELECT TO_DATETIME('2010-01 Ocak', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Şubat', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Mart', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Nisan', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Mayıs', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Haziran', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Temmuz', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Ağustos', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Eylül', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Ekim', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Kasım', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 Aralık', 'yyyy-dd Month');

select 'TO_DATETIME( ,  Mon)';
SELECT TO_DATETIME('2010-01 Ock', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Şbt', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Mrt', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Nsn', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Mys', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Hzr', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Tmz', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Ağs', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Eyl', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Ekm', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Ksm', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 Arl', 'yyyy-dd Mon');

-- text
SELECT TO_DATETIME('2010-01 teIt Ksm', 'yyyy-dd "teıt" Mon');

SELECT TO_DATE('2010-01 teIt Ksm', 'yyyy-dd "teSt" Mon');

select 'TO_DATETIME( ,  PM)';
SELECT TO_DATETIME('2011-05-01 PAZAR 10:11:12 PM', 'yyyy-MM-DD DAY HH:MI:SS PM');
SELECT TO_DATETIME('2011-05-01 PAZAR 10:11:12 AM', 'yyyy-MM-DD DAY HH:MI:SS AM');
SELECT TO_DATETIME('2011-05-01 PAZAR 10:11:12 P.M.', 'yyyy-MM-DD DAY HH:MI:SS P.M.');
SELECT TO_DATETIME('2011-05-01 PAZAR 10:11:12 A.M.', 'yyyy-MM-DD DAY HH:MI:SS A.M.');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;


