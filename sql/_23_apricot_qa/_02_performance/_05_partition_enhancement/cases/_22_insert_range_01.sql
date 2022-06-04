drop table if exists t;
drop table if exists temp;
drop table if exists t__p__p14;
drop table if exists t__p__p15;

create table t(v varchar(10)) partition by range(v) (
partition p0 values less than ('b'),
partition p1 values less than ('c'),
partition p2 values less than ('d'),
partition p3 values less than ('e'),
partition p4 values less than ('f'),
partition p5 values less than ('g'),
partition p6 values less than ('h'),
partition p7 values less than ('i'),
partition p8 values less than ('j'),
partition p9 values less than ('k'),
partition p10 values less than ('l'),
partition p11 values less than ('m'),
partition p12 values less than ('n'),
partition p13 values less than ('o'),
partition p14 values less than ('p'),
partition p15 values less than ('q'),
partition p16 values less than ('r'),
partition p17 values less than ('s'),
partition p18 values less than ('t'),
partition p19 values less than ('u'),
partition p20 values less than ('v'),
partition p21 values less than ('w'),
partition p22 values less than ('x'),
partition p23 values less than ('y'),
partition p24 values less than maxvalue
);

create table temp(v varchar(5));
insert into temp values('a'),('b'),('c'),('d'),('e'),('f'),('g'),('h');
insert into temp values('i'),('j'),('k'),('l'),('m'),('n'),('o'),('p');
insert into temp values('q'),('r'),('s'),('t'),('u'),('v'),('w'),('x'),('y'),('z');

insert into t select t1.v||t2.v from temp t1,temp t2 where t1.v != t2.v;
insert into t select v||cast(rand(-9)%1000 as varchar) from t;
insert into t select v||cast(rand(90)%2000 as varchar) from t;

insert into t select * from t;

select * from db_partition where class_name='t' order by 3;
select * from db_class where class_name='t';

select count(distinct v) from t__p__p14;
select count(distinct v) from t__p__p15;

alter table t reorganize partition p14,p15 into (partition p145 values less than('q'));
select * from db_partition where class_name='t' order by 3;
select * from db_class where class_name='t';

select count(distinct v) from t__p__p14;
select count(distinct v) from t__p__p15;

alter table t reorganize partition p145 into (partition p14 values less than('oz'),partition p15 values less than('q'));
select * from db_partition where class_name='t' order by 3;
select * from db_class where class_name='t';

select count(distinct v) from t__p__p14;
select count(distinct v) from t__p__p15;

alter table t add column i int;
update t set i=position('h' in v);
select * from db_partition where class_name='t' order by 3;
select * from db_class where class_name='t';

select count(distinct v) from t__p__p14;
select count(distinct v) from t__p__p15;

alter table t promote partition p14,p15;
select * from db_partition where class_name='t' order by 3;
select * from db_class where class_name='t';

select count(distinct v) from t__p__p14;
select count(distinct v) from t__p__p15;

insert into t values('p',1000);
select * from t__p__p16 where v='p';

drop t;
drop temp;
drop t__p__p14;
drop t__p__p15;




