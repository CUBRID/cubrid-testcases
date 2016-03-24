--+ holdcas on;

set names utf8;
create class t1(
col1 string collate binary, 
col2 char(10)  collate utf8_tr_cs, 
col3 varchar(10)  collate utf8_tr_cs, 
col4 DATE,
col5 TIME,
col6 TIMESTAMP,
col7 SET,
col8 MULTISET,
col9 SEQUENCE );
INSERT INTO t1 VALUES ('Çç_Ğğ_İı','Çç_Ğğ_İı','Çç_Ğğ_İı','2008-05-26', '14:24:00', '14:24:00 2008-05-26',{'Çç_Ğğ_İı'},{'Çç_Ğğ_İı'},{'Çç_Ğğ_İı'});
INSERT INTO t1 VALUES ('Öö_Şş_Üü',null,'Öö_Şş_Üü','2008-06-26', '10:24:00', '10:25:00 2008-05-26',{'Öö_Şş_Üü'},{'Öö_Şş_Üü'},{'Öö_Şş_Üü'});
INSERT INTO t1 VALUES ('Öö_Şş_Üü阿啊','Öö_Şş_Üü阿啊','Öö_Şş_Üü阿啊','2008-05-26', '14:23:00', '14:24:00 2008-06-26',{'Öö_Şş_Üü阿啊'},{'Öö_Şş_Üü阿啊'},{'Öö_Şş_Üü阿啊'});
INSERT INTO t1 VALUES (null,'Öö_Şş_Üü啊阿','Öö_Şş_Üü啊阿','2009-05-26', '14:25:00', '14:24:00 2008-05-26',null,{'Öö_Şş_Üü啊阿'},null);
INSERT INTO t1 VALUES ('Öö_Şş_Üü啊阿',null,null,'2008-05-28', '14:24:01', '14:24:01 2008-05-26',{'Öö_Şş_Üü啊阿'},null,{'Öö_Şş_Üü啊阿'});

create index t1_index on t1(col9);
--test
SELECT * FROM t1 order by 1,2;
--test
SELECT col9 FROM t1 order by col9;

UPDATE t1 SET col9={'Çç_Ğğ_İı_aa'} WHERE col1='Çç_Ğğ_İı';

DELETE  FROM t1 WHERE col1='Çç_Ğğ_İı';
--test
SELECT * FROM db_index WHERE class_name='t1' order by 1,2;
--test
SELECT col9 FROM t1 order by col9;

drop class t1;

set names iso88591;

commit;
--+ holdcas off;
