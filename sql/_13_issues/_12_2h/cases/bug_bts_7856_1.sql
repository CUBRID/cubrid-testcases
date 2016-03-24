--TEST: [Merge Statement] The tuples that are not updated by the update_clause can be deleted by the delete_clause when the update_clause is with where conditions.


drop table if exists t1, t2;

create table t1(a int, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');
insert into t1 values(4, 'ddd');
insert into t1 values(5, 'eee');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');
insert into t2 values(5, 'EEE');
insert into t2 values(6, 'FFF');



merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.b = t2.b where t1.a > 1
delete where t1.b='bbb';

select * from t1 order by 1;

drop table t1, t2;


create table t1(a int, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');


merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.b = t2.b where t1.a > 3
delete where t1.b='bbb';

select * from t1 order by 1;

drop table t1, t2;

--- default
create table t1(a int , b char(10) default 'zzz');
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10) default 'www');
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');

merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.b = default where t1.a > 1 
delete where t1.b='zzz';

select * from t1 order by 1;

drop table t1, t2;

create table t1(a int , b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');

merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.b = left(t2.b,1) where t1.a > 1
delete where left(t1.b,1)='B';

select * from t1 order by 1;

drop table t1, t2;

--- index
create table t1(a int , b char(10));
create index idx_t1_a on t1(a);
create index idx_t1_b on t1(b);

insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
create index idx_t2_a on t2(a);
create index idx_t2_b on t2(b);

insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(3, 'CCC');

merge into t1 using t2 on (t1.a = t2.a)
when matched then 
update set t1.b = left(t2.b, 1) where t1.a > 1
delete where left(t1.b,1) > 'A';

select * from t1 order by 1;

drop table t1, t2;
