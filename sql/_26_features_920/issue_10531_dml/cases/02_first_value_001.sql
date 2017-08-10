drop table if exists lprocess2_tb;
create table lprocess2_tb(
        id int primary key not null auto_increment,
        groupid int ,
        groupid1 int ,        
        col1 char(20)
);

insert into lprocess2_tb (col1,groupid,groupid1) select null+rownum,1,-1 from db_class x1, db_class x2, db_class x3, db_class x4 limit 10;
insert into lprocess2_tb (col1,groupid,groupid1) select 'abcdeddfafd',1,-1 from db_class x1, db_class x2, db_class x3, db_class x4 limit 10;
insert into lprocess2_tb (col1,groupid,groupid1) select null,1,0 from db_class x1, db_class x2, db_class x3, db_class x4 limit 10;
insert into lprocess2_tb (col1,groupid,groupid1) select '21asdfadfasdf',1,0 from db_class x1, db_class x2, db_class x3, db_class x4 limit 10;
insert into lprocess2_tb (col1,groupid,groupid1) select null,2,-1 from db_class x1, db_class x2, db_class x3, db_class x4 limit 10;
insert into lprocess2_tb (col1,groupid,groupid1) select '22asdfadfasdf',2,-1 from db_class x1, db_class x2, db_class x3, db_class x4 limit 10;

--first_value
select groupid, col1, first_value(col1) over(partition by groupid order by col1) as ret_val from lprocess2_tb order by 1,2,3;
select id, col1, first_value(col1) over(order by col1) as ret_val from lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) over(partition by groupid order by col1) as ret_val from  lprocess2_tb where col1 is not null order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1) as ret_val from  lprocess2_tb where col1 is not null order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1) as ret_val from  lprocess2_tb where col1 is not null order by 1,2,3;
select groupid, col1, first_value(col1) over(partition by groupid order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc) as ret_val,first_value(col1)  over(partition by groupid order by col1 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls first) as ret_val, first_value(col1)  over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 asc) as ret_val, first_value(col1)  over(partition by groupid order by col1 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls first) as ret_val,first_value(col1)  over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls first) as ret_val, first_value(col1)  over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col1, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc) as ret_val,first_value(col1) respect nulls over(partition by groupid order by col1 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls first) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 asc) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls first) as ret_val,first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls first) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col1, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc) as ret_val,first_value(col1) ignore nulls over(partition by groupid order by col1 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 asc) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val,first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

drop table if exists tree;
create table tree as select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc) as ret_val,first_value(col1) ignore nulls over(partition by groupid order by col1 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 asc) as ret_val, first_value(col1) ignore nulls over(partition by groupid order by col1 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, col1, first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val,first_value(col1) ignore nulls over(partition by groupid order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;

select groupid, groupid1, col1, first_value(col1) over(partition by groupid, groupid1 order by col1) as ret_val from lprocess2_tb order by 1,2,3;
select id, col1, first_value(col1) over(order by col1) as ret_val from lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) over(partition by groupid, groupid1 order by col1) as ret_val from  lprocess2_tb where col1 is not null order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1) as ret_val from  lprocess2_tb where col1 is not null order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1) as ret_val from  lprocess2_tb where col1 is not null order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) over(partition by groupid, groupid1 order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc) as ret_val,first_value(col1)  over(partition by groupid, groupid1 order by col1 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 asc) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val,first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1)  over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val,first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 asc) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val,first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) respect nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 asc) as ret_val from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;


select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val,first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 asc) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val,first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1 nulls last,2,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls first,1,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;
select id,groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb group by id order by groupid  desc nulls last,1,3;

drop table if exists tree;
create table tree as select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val,first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls last) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 asc) as ret_val, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 asc) as ret_val2 from  lprocess2_tb order by 1,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;
create table tree as select groupid, groupid1, col1, first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val,first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2,3;
select * from tree order by 1,2,3;
drop table if exists tree;



drop table if exists lprocess2_tb;
upid1 order by col1 desc nulls first) as ret_val,first_value(col1) ignore nulls over(partition by groupid, groupid1 order by col1 desc nulls first) as ret_val2 from  lprocess2_tb order by 1 nulls first,2;
select * from tree order by 1,2,3;
drop table if exists tree;



drop table if exists lprocess2_tb;
