-- Work456/06: INSERT SET/default/expression/scalar subquery and joined UPDATE.
-- Full distinct values derive from literal input models; no physical state is claimed by JDBC.
drop table if exists dml06_forms;

drop table if exists dml06_source;

create table dml06_forms(id int primary key,note int default 77,payload bit varying default X'abcd');

insert into dml06_forms values(1,101,X'19ab23cd45ef'),(2,202,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

insert into dml06_forms set id=3,note=303,payload=X'29bc34de56fa';

insert into dml06_forms(id) values(4);

insert into dml06_forms values(2+3,500+5,cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying));

insert into dml06_forms values(6,(select 606 from db_root),(select cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) from db_root));

select count(*) as n from dml06_forms where (id=1 and note=101 and payload=X'19ab23cd45ef') or (id=2 and note=202 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=3 and note=303 and payload=X'29bc34de56fa') or (id=4 and note=77 and payload=X'abcd') or (id=5 and note=505 and payload=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying)) or (id=6 and note=606 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

select count(*) as n from dml06_forms where 1=1;

update dml06_forms set payload=(select cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying) from db_root),note=111 where id=1;

select count(*) as n from dml06_forms where (id=1 and note=111 and payload=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying)) or (id=2 and note=202 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=3 and note=303 and payload=X'29bc34de56fa') or (id=4 and note=77 and payload=X'abcd') or (id=5 and note=505 and payload=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying)) or (id=6 and note=606 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

select count(*) as n from dml06_forms where 1=1;

create table dml06_source(id int primary key,note int,payload bit varying);

insert into dml06_source values(2,212,X'19ab23cd45ef'),(3,313,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

update dml06_forms r,dml06_source s set r.note=s.note,r.payload=s.payload where r.id=s.id;

select count(*) as n from dml06_forms where (id=1 and note=111 and payload=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying)) or (id=2 and note=212 and payload=X'19ab23cd45ef') or (id=3 and note=313 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=4 and note=77 and payload=X'abcd') or (id=5 and note=505 and payload=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying)) or (id=6 and note=606 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

select count(*) as n from dml06_forms where 1=1;

drop table dml06_source;

drop table dml06_forms;
