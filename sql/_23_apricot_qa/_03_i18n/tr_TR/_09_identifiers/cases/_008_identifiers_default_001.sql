--+ holdcas on;
set names utf8;
--test
CREATE TABLE t(col1 VARCHAR(60) collate binary DEFAULT 'Çç_Ğğ_İı_Öö_Şş_Üü', col2 CHAR(30) collate binary default 'Çç_Ğğ_İı_Öö');
insert into t values(null,'你好你好你好你好你好'),('你好你好你好你好你好你好你好你好你好',null),(null,null);
--test
select col1,DEFAULT(col1),col2,DEFAULT(col2) from t order by 1,col2;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
