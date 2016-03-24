--TEST: [Merge Statement] The tuples that are not updated by the update_clause can be deleted by the delete_clause when the update_clause is with where conditions.


drop table if exists t1, t2;

create table t1(a int, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');


merge into t1 using (select * from t2 where t2.a > 1) as d on (t1.a = d.a)
when matched then 
update set t1.b = d.b where t1.a > 1
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

create trigger trg before update on t1 execute insert into t2 values (NULL, NULL);

merge into t1 using (select * from t2 where t2.a > 1) as d on (t1.a = d.a)
when matched then 
update set t1.b = d.b where t1.a > 3
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

merge into t1 using (select * from t2 where t2.a > 1) as d on (t1.a = d.a)
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

merge into t1 using  (select * from t2 where t2.a > 1) as d on (t1.a = d.a)
when matched then 
update set t1.b = left(d.b,1) where t1.a > 1
delete where left(t1.b,1)='B';

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

create trigger trg before update on t1 execute insert into t2 values (NULL, NULL);

merge into t1 using (select * from t2 where t2.a > 1) as d on (t1.a = d.a)
when matched then 
update set t1.b = left(d.b, 1) where t1.a > 1
delete where left(t1.b,1) > 'B';

select * from t1 order by 1;
select if(count(*)=4, 'ok', 'nok') from t2;

drop table t1, t2;

