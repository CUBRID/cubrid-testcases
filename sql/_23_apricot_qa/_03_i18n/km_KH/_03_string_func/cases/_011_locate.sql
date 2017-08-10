--+ holdcas on;
set names utf8;
CREATE TABLE test_kh ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_km_exp);
insert into test_kh values (1,'សុមករា的មិនាមេសា');
insert into test_kh values (2,null);

--test
select id, name, locate ('ក',name) from test_kh order by 1;
--test
select id, name, locate ('ក',name, 5) from test_kh order by 1;
--test
select id, name, locate (' ',name, 5) from test_kh order by 1;
--test
select id, name, locate ('',name, 5) from test_kh order by 1;
--test
select id, name, locate (null,name, 5) from test_kh order by 1;


drop table test_kh;

set names iso88591;
commit;
--+ holdcas off;