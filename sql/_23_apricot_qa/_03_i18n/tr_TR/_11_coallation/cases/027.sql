--+ holdcas on;

set names utf8;
create class t1(
col1 string, 
col2 char(10)  collate utf8_tr_cs, 
col3 varchar(10)  collate utf8_tr_cs, 
col4 DATE,
col5 TIME,
col6 TIMESTAMP,
col7 SET,
col8 MULTISET,
col9 SEQUENCE );
INSERT INTO t1 VALUES ('Çç_Ğğ_İı','Çç_Ğğ_İı','Çç_Ğğ_İı ','26.05.2008', '14:24:00', '14:24:00 26.05.2008',{'Çç_Ğğ_İı'},{'Çç_Ğğ_İı'},{'Çç_Ğğ_İı'});
INSERT INTO t1 VALUES ('Öö_Şş_Üü',null,'Öö_Şş_Üü ','26.06.2008', '10:24:00', '10:25:00 26.05.2008',{'Öö_Şş_Üü'},{'Öö_Şş_Üü'},{'Öö_Şş_Üü'});
INSERT INTO t1 VALUES ('Öö_Şş_Üü阿啊','Öö_Şş_Üü阿啊','Öö_Şş_Üü阿啊','26.05.2008', '14:23:00', '14:24:00 26.06.2008',{'Öö_Şş_Üü阿啊'},{'Öö_Şş_Üü阿啊'},{'Öö_Şş_Üü阿啊'});
INSERT INTO t1 VALUES (null,'Öö_Şş_Üü啊阿','Öö_Şş_Üü啊阿','26.05.2009', '14:25:00', '14:24:00 26.05.2008',null,{'Öö_Şş_Üü啊阿'},null);
INSERT INTO t1 VALUES ('Öö_Şş_Üü啊阿',null,null,'28.05.2008', '14:24:01', '14:24:01 26.05.2008',{'Öö_Şş_Üü啊阿'},null,{'Öö_Şş_Üü啊阿'});

create  unique index t1_index on t1(trim(col3));
--test
SELECT * FROM t1 order by 1,2;
--test
SELECT trim(col3) FROM t1 order by trim(col3);

UPDATE t1 SET col3='Öö_Şş_Üü你好' WHERE col3='Öö_Şş_Üü阿啊';

DELETE  FROM t1 WHERE col3='Öö_Şş_Üü啊阿';
--test
SELECT * FROM db_index WHERE class_name='t1' order by 1,2;
--test
SELECT trim(col3) FROM t1 order by trim(col3);

drop class t1;
set names iso88591;

commit;
--+ holdcas off;

