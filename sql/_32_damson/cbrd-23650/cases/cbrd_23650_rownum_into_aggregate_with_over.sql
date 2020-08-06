drop table if exists t1;

create table t1 (a int primary key, b int);

insert into t1 values (1, 1), (2, 1), (3, 1), (4, 1), (5, 2), (6, 2), (7, 2), (8, 2);

select rownum, sum(rownum) over (partition by a) from t1;
select sum(rownum) over (partition by b) from t1;
select count(*) over () from t1 limit 2;
select rownum, sum(rownum) over (partition by a) from t1;
select sum(rownum) over (partition by b) from t1;
select count(*) over () from t1 limit 2;

select count(*) over(order by b) from t1 limit 6;
select count(*) over(order by b) from t1 limit 6;
select count(*) over(partition by b) from t1 limit 5;
select count(*) over(partition by b) from t1 limit 5;
select count(*) over(partition by null order by null) from t1 limit 4;
select count(*) over(partition by null order by null) from t1 limit 4;

drop table t1;


create table t1(a int, b int, c varchar(3));

insert into t1 values(1, 2, 'aaa');
insert into t1 values(2, 3, 'bbb');
insert into t1 values(3, 1, 'bbb');
insert into t1 values(4, 3, 'bbb');
insert into t1 values(5, 1, 'aaa');

select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 order by a limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 order by a limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where inst_num() > 1 and inst_num() < 4;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where inst_num() > 1 and inst_num() < 4;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where inst_num() mod 2 = 1;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where inst_num() mod 2 = 1;


drop table t1;


create table t1(a int primary key, b int, c varchar(3));

insert into t1 values(1, 2, 'aaa');
insert into t1 values(2, 3, 'bbb');
insert into t1 values(3, 1, 'bbb');
insert into t1 values(4, 3, 'bbb');
insert into t1 values(5, 1, 'aaa');

select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where a > 0 limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where a > 0 limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where a > 0 and inst_num() > 1 and inst_num() < 4;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where a > 0 and inst_num() > 1 and inst_num() < 4;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where a > 0 and inst_num() mod 2 = 1;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from t1 where a > 0 and inst_num() mod 2 = 1;


drop table t1;
