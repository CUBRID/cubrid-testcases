--+ holdcas on;

drop table if exists md_nchar1;

drop table if exists md_nchar2;

create table md_nchar1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 nchar(1024) primary key);

create table md_nchar2(col1 nchar(500), id2 numeric(10, 5), index i(id2 desc, col1));

update md_nchar2 as m2 inner join (select id1, trim(substr(col2, 1, 6)) as col2 from md_nchar1 where left(col2, 3) = test(n'abc',300)) m1 on left(m1.col2, 3)=left(m2.col1, 3) set m2.id2=m1.id1;


insert into md_nchar1 values(11111.11111, '2011-09-01 12:12:12', n'cubrid'), (22222.22222, '2011-09-01 12:12:13', n'test'), (33333.33333, '2011-09-01 12:12:14', n'abc');

insert into md_nchar2 values(n'cubrid', 1234.12345), (n'abcabc', 3456.34555), (n'a', 55555.55555);

update md_nchar2 as m2 inner join (select id1, trim(substr(col2, 1, 6)) as col2 from md_nchar1 where left(col2, 3) =trim(col2)) m1 on left(m1.col2, 3)=left(m2.col1, 3) set m2.id2=m1.id1;      


drop table md_nchar1;

drop table md_nchar2;

--+ holdcas off;