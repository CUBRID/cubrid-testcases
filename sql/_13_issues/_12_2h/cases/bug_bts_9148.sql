--TEST: Query execution failure #10946 when executing union statement


drop table if exists u1, u2;


create table u1 (a varchar(1));
create table u2 (a varchar(2));
insert into u1 values ('1');
insert into u2 values ('22');

select a from (select a from u1 union all select a from u2) t(a) order by 1;

drop u1, u2;



create table u1 (a varchar(100));
create table u2 (a varchar(300));
insert into u1 values (repeat('1', 100));
insert into u2 values (repeat('2', 300));

select length(a) from (select a from u1 union all select a from u2) t(a) order by 1;

drop u1, u2;



drop table if exists t1, t2, t3, t4, t5;

create table t1(a char(1), b varchar(1));
create table t2(a char(2), b varchar(2));
create table t3(a char(100), b varchar(100));
create table t4(a char(10), b varchar(10));
create table t5(a char(999), b varchar(999));

insert into t1 values('a', 'a');
insert into t1 values('b', 'b');
insert into t2 values('aa', 'aa');
insert into t3 values('aaaaaaaaaaaaaaaaaaaaaaa', 'aaaaaaaaaaaaaaaaaaaaaaaaaa');
insert into t3 values('bbbbb', 'bbbbb');
insert into t4 values('aaaaaaaaaa', 'aaaaaaaaaa');
insert into t5 values('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz', 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
insert into t5 values('ggggggggggggggggggggggggggggggggggggggggggggggggg', 'ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');

--char(n)
select * from (select a from t1 union all select a from t2 union all select a from t4 union all select a from t3 union all select a from t5) order by 1;
select * from (select a from t1 union all select a from t2 union all select a from t3 union all select a from t4 union all select a from t5) order by 1;
--varchar(n)
select * from (select b from t1 union all select b from t2 union all select b from t4 union all select b from t3 union all select b from t5) order by 1;
select * from (select b from t1 union all select b from t2 union all select b from t3 union all select b from t4 union all select b from t5) order by 1;
--char(n) + varchar(n)
select * from (select a from t1 union all select b from t2 union all select a from t4 union all select b from t3 union all select b from t5) order by 1;
select * from (select a from t1 union all select b from t3 union all select a from t4 union all select b from t2 union all select b from t5) order by 1;

drop table t1, t2, t3, t4, t5;












