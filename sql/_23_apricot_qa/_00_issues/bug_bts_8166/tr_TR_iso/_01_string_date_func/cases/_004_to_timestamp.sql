-- to_timestamp
--+ holdcas on;
set names iso88591;
set system parameters 'intl_date_lang = tr_TR';

select 'TO_TIMESTAMP( , DAY   )';
SELECT TO_TIMESTAMP('2011-05-01 PAZAR 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-02 PAZARTESI 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-03 SALI 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-04 CARSAMBA 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-05 PERSEMBE 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-06 CUMA 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');
SELECT TO_TIMESTAMP('2011-05-07 CUMARTESI 10:11:12', 'yyyy-MM-DD DAY HH:MI:SS');

select 'TO_TIMESTAMP( ,  day )';
SELECT TO_TIMESTAMP('2011-05-01 pazar', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-02 pazartesi', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-03 Sali', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-04 carsamba', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-05 persembe', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-06 cuma', 'yyyy-MM-DD day');
SELECT TO_TIMESTAMP('2011-05-07 cumartesi', 'yyyy-MM-DD day');

select 'TO_TIMESTAMP( , DY )';
SELECT TO_TIMESTAMP('2011-05-01 PZ', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-02 PT', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-03 SA', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-04 CA', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-05 Pe', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-06 Cu', 'yyyy-MM-DD DY');
SELECT TO_TIMESTAMP('2011-05-07 Ct', 'yyyy-MM-DD DY');

select 'TO_TIMESTAMP( ,  dy )';
SELECT TO_TIMESTAMP('2011-05-01 pz', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-02 pt', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-03 sa', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-04 ca', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-05 pe', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-06 cu', 'yyyy-MM-DD dy');
SELECT TO_TIMESTAMP('2011-05-07 ct', 'yyyy-MM-DD dy');

-- month
select 'TO_TIMESTAMP( ,  MONTH)';
SELECT TO_TIMESTAMP('2010-01 OCAK', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 SUBAT', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 MART', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 NISAN', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 MAYIS', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 HAZIRAN', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 TEMMUZ', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 AGUSTOS', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 EYLUL', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 EKIM', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 KASIM', 'yyyy-dd MONTH');
SELECT TO_TIMESTAMP('2010-01 ARALIK', 'yyyy-dd MONTH');

select 'TO_TIMESTAMP( ,  month)';
SELECT TO_TIMESTAMP('2010-01 ocak', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 subat', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 mart', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 nisan', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 mayis', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 haziran', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 temmuz', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 agustos', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 eylul', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 ekim', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 kasim', 'yyyy-dd month');
SELECT TO_TIMESTAMP('2010-01 aralik', 'yyyy-dd month');


select 'TO_TIMESTAMP( ,  MON)';
SELECT TO_TIMESTAMP('2010-01 OCK', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 SBT', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 MRT', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 NSN', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 MYS', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 HZR', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 TMZ', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 AGS', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 EYL', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 EKM', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 KSM', 'yyyy-dd MON');
SELECT TO_TIMESTAMP('2010-01 ARL', 'yyyy-dd MON');

select 'TO_TIMESTAMP( ,  mon)';
SELECT TO_TIMESTAMP('2010-01 ock', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 sbt', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 mrt', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 nsn', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 mys', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 hzr', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 tmz', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 ags', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 eyl', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 ekm', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 ksm', 'yyyy-dd mon');
SELECT TO_TIMESTAMP('2010-01 arl', 'yyyy-dd mon');

select 'TO_TIMESTAMP( ,  Month)';
SELECT TO_TIMESTAMP('2010-01 Ocak', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Subat', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Mart', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Nisan', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Mayis', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Haziran', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Temmuz', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Agustos', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Eylul', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Ekim', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Kasim', 'yyyy-dd Month');
SELECT TO_TIMESTAMP('2010-01 Aralik', 'yyyy-dd Month');

select 'TO_TIMESTAMP( ,  Mon)';
SELECT TO_TIMESTAMP('2010-01 Ock', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Sbt', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Mrt', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Nsn', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Mys', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Hzr', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Tmz', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Ags', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Eyl', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Ekm', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Ksm', 'yyyy-dd Mon');
SELECT TO_TIMESTAMP('2010-01 Arl', 'yyyy-dd Mon');

-- text
SELECT TO_TIMESTAMP('2010-01 teIt Ksm', 'yyyy-dd "teit" Mon');

SELECT TO_DATE('2010-01 teIt Ksm', 'yyyy-dd "teSt" Mon');

select 'TO_TIMESTAMP( ,  PM)';
SELECT TO_TIMESTAMP('2011-05-01 PAZAR 10:11:12 PM', 'yyyy-MM-DD DAY HH:MI:SS PM');
SELECT TO_TIMESTAMP('2011-05-01 PAZAR 10:11:12 AM', 'yyyy-MM-DD DAY HH:MI:SS AM');
SELECT TO_TIMESTAMP('2011-05-01 PAZAR 10:11:12 P.M.', 'yyyy-MM-DD DAY HH:MI:SS P.M.');
SELECT TO_TIMESTAMP('2011-05-01 PAZAR 10:11:12 A.M.', 'yyyy-MM-DD DAY HH:MI:SS A.M.');

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
