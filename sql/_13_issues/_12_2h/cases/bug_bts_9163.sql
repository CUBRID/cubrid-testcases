set system parameters 'create_table_reuseoid=no';
--TEST: [Merge Statement] delete_clause does not work when merging in to a view.


drop table if exists t1, t2;


create table t1(a int, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');

create view vv as select * from t1 where t1.a > 1;

merge into vv using t2 on (vv.a = t2.a)
when matched then 
update set vv.b = t2.b where vv.a > 1
delete where vv.b='bbb';

select * from t1 order by 1;
select * from vv order by 1;

drop table t1, t2;
drop view vv;


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

create trigger trg before update on t1 execute insert into t2 values (NULL, NULL);

create view vv as select * from t1 where t1.a > 1;

merge into vv using t2 on (vv.a = t2.a)
when matched then 
update set vv.b = t2.b where vv.a > 1
delete where vv.b='bbb';

select * from t1 order by 1;
select * from vv order by 1;
select if(count(*)=8, 'ok', 'nok') from t2;

drop table t1, t2;
drop view vv;

--- default
create table t1(a int , b char(10) default 'zzz');
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10) default 'www');
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');

create view vv as select * from t1 where t1.a > 1;

merge into vv using t2 on (vv.a = t2.a)
when matched then 
update set vv.b = default where vv.a > 1 
delete where vv.b='zzz';

select * from t1 order by 1;
select * from vv order by 1;

drop table t1, t2;
drop view vv;

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

create trigger trg before update on t1 execute insert into t2 values (NULL, NULL);

create view vv as select * from t1 where t1.a > 1;

merge into vv using t2 on (vv.a = t2.a)
when matched then 
update set vv.b = left(t2.b,1) where vv.a > 1
delete where left(vv.b,1)='B';

select * from vv order by 1;
select * from t1 order by 1;

drop table t1, t2;
drop view vv;

--- index
create table t1(a int , b char(10));
create index idx_t1_a on t1(a);
create index idx_t1_b on t1(b);

insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
create index idx_t2_a on t2(a);
create index idx_t2_b on t2(b);

insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');

create view vv as select * from t1 where t1.a > 1;

create trigger trg before update on t1 execute insert into t2 values (NULL, NULL);

merge into vv using t2 on (vv.a = t2.a)
when matched then 
update set vv.b = left(t2.b, 1) where vv.a > 1
delete where left(vv.b, 1) = 'B';

select * from vv order by 1;
select * from t1 order by 1;

drop table t1, t2;
drop view vv;
set system parameters 'create_table_reuseoid=yes';
