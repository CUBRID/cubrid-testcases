--+ holdcas on;
set names utf8;
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_tr_cs_uca);
insert into test_tr values (1,'Gülen');
insert into test_tr values (2,'Ğüler'); 
insert into test_tr values (3,'İzgi');
insert into test_tr values (4,'İzgi İxxettin');
insert into test_tr values (5,null);

--test
select id, name, reverse (name) from test_tr order by 1;
drop table test_tr;
set names iso88591;
commit;
--+ holdcas off;
