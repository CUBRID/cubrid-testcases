--+ holdcas on;
set names utf8;

--test
select substring_index('cun.oșt.inț.ă' collate utf8_ro_cs,'.',2);
--test
select substring_index('cun*oșt*inț*ă','*',2.2);


create table test_ro(id int, name varchar(20) collate utf8_ro_cs);
insert into test_ro values(100, 'cunÎĂoștÎĂințÎĂă');


--test
select id, name, substring_index(name,'ÎĂ',100) from test_ro;
--test
select id, name, substring_index(name,'ÎĂ',-1) from test_ro;
--test
select id, name, substring_index(name,null,-1) from test_ro;
--test
select id, name, substring_index(name,'ÎĂ',3) from test_ro;

drop table test_ro;

set names iso88591;
commit;
--+ holdcas off;
