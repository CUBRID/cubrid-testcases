--+ holdcas on;
set names utf8;
CREATE TABLE test_cn ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_gen);
insert into test_cn values (1,'今天明天科学程序员');
insert into test_cn values (2,null);

--test
select id, name, locate ('ü',name) from test_cn order by 1;
--test
select id, name, locate ('ü',name, 5) from test_cn order by 1;
--test
select id, name, locate (' ',name, 5) from test_cn order by 1;
--test
select id, name, locate ('',name, 5) from test_cn order by 1;
--test
select id, name, locate (null,name, 5) from test_cn order by 1;


drop table test_cn;
set names iso88591;
commit;
--+ holdcas off;

