drop table if exists md1,md2,action_tbl;
create table md1(id1 int primary key, col1 varchar,col2 timestamp on update current_timestamp);
insert into md1(id1,col1) values(11, 'aaa'), (22, 'bbb');

create table md2(id2 smallint, col2 varchar,col3 timestamp on update current_timestamp);
insert into md2(id2,col2) values(22, 'ccc'), (22, 'ddd');

create table action_tbl(a int primary key auto_increment, b char(20),c timestamp on update current_datetime);
create trigger aft_upd after update on md1
execute insert into action_tbl(b) values('AFTER UPDATE');
select * from md1 m1 inner join md2 m2 on m2.id2=m1.id1 order by 1,2,3,4,5,6;
update md1 m1 inner join md2 m2 on m1.id1=m2.id2 set m1.col1=m2.col2;
select if(current_timestamp-m1.col2>=0 and current_timestamp-m1.col2<10,'ok','nok') from md1 m1 inner join md2 m2 on m2.id2=m1.id1;
select * from action_tbl order by 1,2,3;
drop trigger aft_upd;
select if(current_timestamp-col2>=0 and current_timestamp-col2<10,'ok','nok') from md1 where id1=22;
select * from md2 order by 1,2,3;
drop table if exists md1,md2,action_tbl;
