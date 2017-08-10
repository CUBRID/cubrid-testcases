--+ holdcas on;
set names utf8;
--Test
SELECT 'aöşüz' + 'öşü';
--Test
SELECT 'aöşüz' || 'öşü';
--Test
select concat('ı','İ',null);
--Test
select concat_ws('ö','Salı','PAZARTESİ',null);
--Test
select concat_ws('ö','Salı','PAZARTESİ','abcd');
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_tr_cs_uca);
--Test
insert into test_tr values (1,concat('ı','İ'));
--Test
insert into test_tr values (1,concat('a',CURDATE()));
--Test
insert into test_tr values (1,concat('ö',SYS_DATE));
--Test
insert into test_tr values (1,concat_ws('a',CURDATE()));
--Test
insert into test_tr values (1,concat_ws('ö',CURDATE()));
drop table test_tr;
set names iso88591;
commit;
--+ holdcas off;
