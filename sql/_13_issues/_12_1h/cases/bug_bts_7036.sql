--TEST:  [Multi-table Update] Number of affected rows is incorrect when updating 1 row that joins with 2 rows from another table.


create table md1(id1 int primary key, col1 varchar);
insert into md1 values(11, 'aaa'), (22, 'bbb');

create table md2(id2 smallint, col2 varchar);
insert into md2 values(22, 'ccc'), (22, 'ddd'), (22, 'eee'), (11, 'bbb'), (11, 'ddd');


--2 rows affected
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m1.col1=m2.col2;

--2 rows affected
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m1.col1=m2.col2;


--2 rows affected
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m1.col1=m2.col2;


--5 rows affcted
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m2.col2=m1.col1;

--5 rows affcted
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m2.col2=m1.col1;
         
--5 rows affcted
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m2.col2=m1.col1;


drop table md1, md2;
