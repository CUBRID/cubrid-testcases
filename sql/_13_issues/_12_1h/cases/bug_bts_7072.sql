--TEST: Trigger action is not correct when updating multiple tables.


create table md1(id1 int primary key, col1 varchar);
insert into md1 values(11, 'aaa'), (22, 'bbb');

create table md2(id2 smallint, col2 varchar);
insert into md2 values(22, 'ccc'), (22, 'ddd'), (22, 'eee'), (11, 'bbb'), (11, 'ddd');

--trigger action table
create table action_tbl1(a int primary key auto_increment, b char(20));
create table action_tbl2(a int primary key auto_increment, b char(20));

--create trigger
create trigger aft_upd after update on md1
execute insert into action_tbl1(b) values('AFTER UPDATE');
create trigger bef_upd before update on md2
execute insert into action_tbl2(b) values('BEFORE UPDATE');

--2 rows affected
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m1.col1=m2.col2;
select if(count(*)=2, 'ok', 'nok') from action_tbl1;

--2 rows affected
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m1.col1=m2.col2;
select if(count(*)=4, 'ok', 'nok') from action_tbl1;


--2 rows affected
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m1.col1=m2.col2;
select if(count(*)=6, 'ok', 'nok') from action_tbl1;


--5 rows affcted
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m2.col2=m1.col1;
select if(count(*)=5, 'ok', 'nok') from action_tbl2;

--5 rows affcted
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m2.col2=m1.col1;
select if(count(*)=10, 'ok', 'nok') from action_tbl2;
         
--5 rows affcted
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m2.col2=m1.col1;
select if(count(*)=15, 'ok', 'nok') from action_tbl2;


drop trigger aft_upd, bef_upd;
drop table md1, md2, action_tbl1, action_tbl2;
