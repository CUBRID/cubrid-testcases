--+ holdcas on;
set names utf8;
CREATE TABLE test_jp ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ja_exp);
insert into test_jp values (1,'いイ基盤的繁体中国語');
insert into test_jp values (2,null);

--test
select id, name, locate ('詳',name) from test_jp order by 1;
--test
select id, name, locate ('詳',name, 5) from test_jp order by 1;
--test
select id, name, locate (' ',name, 5) from test_jp order by 1;
--test
select id, name, locate ('',name, 5) from test_jp order by 1;
--test
select id, name, locate (null,name, 5) from test_jp order by 1;


drop table test_jp;
set names iso88591;
commit;
--+ holdcas off;

