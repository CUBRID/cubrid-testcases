--+ holdcas on;

set names utf8;
create class t1(
col1 string collate binary, 
col2 char(10)  collate utf8_tr_cs, 
col3 varchar(10)  collate utf8_tr_cs, 
col4 DATE,
col5 TIME,
col6 TIMESTAMP


);
INSERT INTO t1 VALUES ('Çç_Ğğ_İı','Çç_Ğğ_İı','Çç_Ğğ_İı','2008-05-26', '14:24:00', '14:24:00 2008-05-26');
INSERT INTO t1 VALUES ('Öö_Şş_Üü',null,'Öö_Şş_Üü','2008-05-26', '14:24:00', '14:24:00 2008-05-26');
INSERT INTO t1 VALUES ('Öö_Şş_Üü阿啊','Öö_Şş_Üü阿啊','Öö_Şş_Üü阿啊','2008-05-26', '14:24:00', '14:24:00 2008-05-26');
INSERT INTO t1 VALUES (null,'Öö_Şş_Üü啊阿','Öö_Şş_Üü啊阿','2008-05-26', '14:24:00', '14:24:00 2008-05-26');
INSERT INTO t1 VALUES ('Öö_Şş_Üü啊阿',null,null,'2008-05-26', '14:24:00', '14:24:00 2008-05-26');

create index t1_index on t1(col2) where col1>='Çç_Ğğ_İı';
--test
SELECT * FROM t1 where col1>='Çç_Ğğ_İı' order by 1,2;
--test
SELECT col2 FROM t1 where col1>='Çç_Ğğ_İı' order by col2;

UPDATE t1 SET col2='Öö_Şş_Üü你好' WHERE col2='Öö_Şş_Üü阿啊';

DELETE  FROM t1 WHERE col2='Öö_Şş_Üü啊阿';
--test
SELECT * FROM db_index WHERE class_name='t1'  order by 1,2;
--test
SELECT col2 FROM t1 where col1>='Çç_Ğğ_İı' order by col2;

drop class t1;
set names iso88591;

commit;
--+ holdcas off;

