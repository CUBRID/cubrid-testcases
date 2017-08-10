--+ holdcas on;
set names utf8;
--Test
SELECT 'să' + 'plouă';
--Test
SELECT 'Sâmb' || 'ătă';
--Test
select concat('Î','î',null);
--Test
select concat_ws('O ','să ','plouă',null);
--Test
select concat_ws('O ','să ','plouă','abcd');
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ro_cs);
--Test
insert into test_ro values (1,concat('ș','Ș'));
--Test
insert into test_ro values (2,concat('a',123)));
--Test
insert into test_ro values (3,concat('Ț',123));
--Test
insert into test_ro values (4,concat('ț',123));
--Test
insert into test_ro values (6,concat('î',123));
--Test
insert into test_ro values (7,concat('ş',123));
--Test
insert into test_ro values (8,concat('ţ',123));

select * from test_ro order by 1;

drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;
