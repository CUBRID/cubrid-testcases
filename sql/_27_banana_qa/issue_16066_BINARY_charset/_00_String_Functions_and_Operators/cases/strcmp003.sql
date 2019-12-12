--+ holdcas on;

set names utf8;
create class t1(
id int,
col1 string collate binary, 
col2 char(10)  collate utf8_tr_cs, 
col3 varchar(10)  collate utf8_tr_cs );
INSERT INTO t1 VALUES (1,'Çç_Ğğ_İı','Çç_Ğğ_İı','Çç_Ğğ_İı');
INSERT INTO t1 VALUES (2,'Öö_Şş_Üü',null,'Öö_Şş_Üü');
INSERT INTO t1 VALUES (3,'Öö_Şş_Üü阿啊','Öö_Şş_Üü阿啊','Öö_Şş_Üü阿啊');
INSERT INTO t1 VALUES (4,null,'Öö_Şş_Üü啊阿','Öö_Şş_Üü啊阿');
INSERT INTO t1 VALUES (5,'Öö_Şş_Üü啊阿',null,null);

create index t1_index on t1(col2) where col1>='Çç_Ğğ_İı';
--test
SELECT id,strcmp(col1, col2) from t1 order by 1;
SELECT id,strcmp(col1 collate iso88591, col2 collate iso88591) order by 1;


drop class t1;
set names iso88591;

commit;
--+ holdcas off;


