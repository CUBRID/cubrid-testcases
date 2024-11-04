drop if exists t;
create table t(id int);
insert into t values (1),(2),(3),(4);
select * from t limit 3 offset 1;
select * from t limit 3 offset 3;
select * from t limit 3 offset 30;
drop t;

create table offset;
create table t(offset int);
drop t;
drop offset;

create table t(id int);
insert into t select rownum from db_class limit 40;
select * from t order by 1 limit 5,10;
select * from t order by 1limit 5,10 offset 4;
select * from t order by 1 limit 10 offset 4;
select * from t order by 1limit 10 offset -4;
select * from t order by 1limit 40 offset 4+9;
select * from t order by 1 limit 100 offset 30; 
select * from (select * from t order by 1 limit 20,10) t1 order by 1 limit 5 offset 3;
select * from t order by id desc limit 10 offset 4 ;

prepare st from 'select * from t order by id desc limit ? offset ?';
execute st using 4,10;
deallocate prepare st;
drop t;

create table t(id int auto_increment(3,4));
insert into t select NULL from db_class limit 20;
prepare st from 'select * from (select * from t limit ? offset ?)  t1 order by 1 desc limit ? offset ?';
execute st using  7,3,3,2;
deallocate prepare st;
drop t;

create table t(id varchar(10));
insert into t values('abc'),('dbb'),('abb'),(' tt'),('ta'),(' ta '),('o'),('b'),('a'),('c ');
prepare st from 'select * from (select * from t limit ? offset ?)  t1 order by 1 desc limit ? offset ?';
execute st using 8,1,4,4;
deallocate prepare st;
drop t;

create table t(id int) partition by hash(id) partitions 3;
insert into t select rownum from db_class limit 40;
select * from t order by 1 limit 5,10;
select * from t order by 1 limit 10 offset 4;
select * from t order by 1 limit 100 offset 30; 
select * from (select * from t order by 1 limit 20,10) t1 order by 1 desc limit 5 offset 3;
select * from t order by id desc limit 10 offset 4 ;


insert into t select * from t order by 1 limit 30;
insert into t select * from t order by 1 limit 20;
insert into t select * from t order by 1 limit 10;

select id,count(*) from t group by id limit 10 offset 4;
select id,count(*) from t group by id order by id desc limit 10 offset 4;
delete from t;
insert into t select rownum from db_class limit 40;
delete from t where id in (select id from t order by 1 desc limit 10 offset 9);
select * from t where id>21 and id <32;

delete from t where id>10;
select * from t t1,t t2 where t1.id=t2.id order by t1.id limit 7 offset 4;
select * from t union all select * from t order by id limit 20 offset 3;

create index i_t_id on t(id);
select * from t union all select * from t order by id limit 20 offset 3;
select t1.id,t2.id from t t1 left join t t2 on t1.id<t2.id order by 2,1 limit 3 offset 10;
drop t;

create table t(i int primary key) partition by range(i) (partition p0 values less than(20),partition p1 values less than maxvalue);
insert into t select rownum from db_class limit 40;
alter table t promote partition p0;

select * from t__p__p0 order by 1 limit 10 offset 3;
select * from t order by 1 limit 10 offset 3;

drop t__p__p0;
drop t;

create table t(i int,j int) partition by hash(i) partitions 5;
insert into t select rownum,rownum%3 from db_class limit 40;
select * from (select * from t order by 2,1 desc limit 20,10) t1 order by 1 desc,2 limit 5 offset 3;

drop t;






















