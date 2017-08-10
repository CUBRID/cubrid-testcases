drop table if exists t;
drop table if exists temp;
drop table if exists t__p__p145;

create table t(v varchar(10)) partition by range(upper(v)) (
partition p0 values less than ('B'),
partition p1 values less than ('C'),
partition p2 values less than ('D'),
partition p3 values less than ('E'),
partition p4 values less than ('F'),
partition p5 values less than ('G'),
partition p6 values less than ('H'),
partition p7 values less than ('I'),
partition p8 values less than ('J'),
partition p9 values less than ('K'),
partition p10 values less than ('L'),
partition p11 values less than ('M'),
partition p12 values less than ('N'),
partition p13 values less than ('O'),
partition p14 values less than ('P'),
partition p15 values less than ('Q'),
partition p16 values less than ('R'),
partition p17 values less than ('S'),
partition p18 values less than ('T'),
partition p19 values less than ('U'),
partition p20 values less than ('V'),
partition p21 values less than ('W'),
partition p22 values less than ('X'),
partition p23 values less than ('Y'),
partition p24 values less than maxvalue
);

create table temp(v varchar(5));
insert into temp values('a'),('B'),('C'),('d'),('e'),('f'),('g'),('H');
insert into temp values('i'),('j'),('K'),('l'),('m'),('n'),('o'),('p');
insert into temp values('Q'),('r'),('s'),('t'),('u'),('v'),('W'),('x'),('y'),('z');
insert into t select t1.v||t2.v from temp t1,temp t2 where t1.v != t2.v;
insert into t select v||cast(rand(-9)%1000 as varchar) from t;
insert into t select v||cast(rand(90)%2000 as varchar) from t;

select * from db_partition where class_name='t' order by 2;
select * from db_class where class_name='t';

select distinct v from t__p__p14 where v like 'p%' order by v desc;
select count(*) from t__p__p15 where v like 'p%' order by v desc;
select count(*) from t__p__p15;

insert /*+ recompile*/ into t select user from t limit 40;
insert /*+ recompile*/ into t (select 'ax' from t limit 40);
insert /*+ recompile*/ into t (select 'ax' from t limit 20) union all (select 'fx' from t limit 20);
insert /*+ recompile*/ into t (select 'ox' from t limit 40);
alter table t reorganize partition p14,p15 into (partition p145 values less than('Q'));
insert /*+ recompile*/ into t (select 'ox' from t limit 40);

select * from db_partition where class_name='t' order by 2;
select * from db_class where class_name='t';

select count(distinct v) from t__p__p145;

alter table t reorganize partition p145 into (partition p14 values less than('OZ'),partition p15 values less than('Q'));
insert /*+ recompile*/ into t (select 'ox' from t limit 400000);
select * from db_partition where class_name='t' order by 2;
select * from db_class where class_name='t';

select count(*) from t__p__p145 where v='ox' order by v desc;
select count(*) from t where v='ox' order by v desc;

alter table t add column i int;
update t set i=position('H' in v);
select * from db_partition where class_name='t' order by 2;
select * from db_class where class_name='t';

alter table t reorganize partition p14,p15 into(partition p145 values less than('Q'));
select count(*) from t__p__p145 order by v desc;

alter table t promote partition p145;
select * from db_partition where class_name='t' order by 2;
select * from db_class where class_name='t';

select count(distinct v) from t__p__p145;

insert into t values('p',100);
select * from t__p__p0 where v='p';

drop t;
drop temp;
drop t__p__p145;



















