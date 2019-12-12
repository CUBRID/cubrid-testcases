--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ro_cs);
insert into test_ro values (1,'ĂĂĂ*ĂĂ');
insert into test_ro values (2,'abcÎțiĂÎțiĂÎți'); 
insert into test_ro values (3,'*Ă*Î*Î*ț*ț');
insert into test_ro values (4,'111Ă*Î*11Ă*Î*');
insert into test_ro values (5,null);

--test
select id, name, instr (name,'Ă') from test_ro order by 1;
--test
select id, name, instr (name,'Ă',-1) from test_ro order by 1;
--test
select id, name, instr (name,'Îț',-3) from test_ro order by 1;
--test
select id, name, instr (name,'Î',5) from test_ro order by 1;
--test
select id, name, instr (name,'Ă*') from test_ro order by 1;

drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;

