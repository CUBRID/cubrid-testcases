drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(to_char(a))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(a) values('a');

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(to_char(b))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(b) values('a');

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(to_char(c))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(c) values('a');
insert into t(c) values('10');
select * from t order by c;

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(to_char(d))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(d) values('a');
insert into t(d) values('10');
select d from t order by d;

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(to_char(e))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(e) values('a');
insert into t(e) values('10');
select e from t order by e;

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(to_char(f))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(f) values('a');
insert into t(f) values('10');
insert into t(f) values('1953-05-24');
select f from t order by f;

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(to_char(g))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(g) values('a');
insert into t(g) values('10');
insert into t(g) values('1953-05-24');
insert into t(g) values('15:30:30');
select g from t order by g;

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(to_char(h))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(h) values('a');
insert into t(h) values('10');
insert into t(h) values('1953-05-24');
insert into t(h) values('15:30:30');
insert into t(h) values('1988-08-24 15:30:30');
insert into t(h) values('1988-08-24 15:30:30.669');
select h from t order by h;

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime ) partition by range(to_char(i))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(i) values('a');
insert into t(i) values('10');
insert into t(i) values('1953-05-24');
insert into t(i) values('15:30:30');
insert into t(i) values('1988-08-24 15:30:30');
insert into t(i) values('1988-08-24 15:30:30.669');
select i from t order by i;

drop table if exists t;
create table t(a char(200) ,b varchar ,c smallint ,d int ,e bigint ,f date,g time ,h timestamp ,i datetime,j double ) partition by range(to_char(j))
(
partition p0 values less than ('dddd'),
partition p1 values less than ('kkk'),
partition p2 values less than ('ww')
);
alter table t add partition (partition p3 values less than ('zzzzzzzzzzzzzzzzzzzzzzz'));
insert into t(j) values(10.15);
drop table t;

drop table if exists t; 
create table t(b varchar(100)) partition by range(to_char(b)) 
( 
  partition p0 values less than ('10000') 
); 
drop table if exists t; 
create table t(b int ) partition by range(to_char(b)) 
( 
  partition p0 values less than (10000) 
); 
drop table if exists t; 
create table t(b char(5)) partition by range(to_char(b)) 
( 
  partition p0 values less than ('dddd') 
);
drop table if exists t; 
create table t(b varchar) partition by range(to_char(b)) 
( 
  partition p0 values less than ('dddd') ,
  partition p1 values less than maxvalue
); 
insert into t values(10);
insert into t values('11');
select * from t order by 1;
drop t;

drop table if exists t; 
create table t(b varchar) partition by list(to_char(b)) 
( 
  partition p0 values in  ('dddd') 
); 
alter table t add partition (partition p1 values in ('10'));
insert into t values(10);
insert into t values('11');
insert into t values('dddd');
select * from t order by 1;
drop t;


drop table if exists t; 
create table t(b char(5)) partition by hash(to_char(b)) 
partitions 4;

drop table if exists t;
create table t(i char(10));
insert into t values ('a');
insert into t values ('b');
insert into t values ('c');
alter table t partition by hash(to_char(i)) partitions 7;
drop table if exists t;
create table t(i char(10));
insert into t values ('a');
insert into t values ('b');
insert into t values ('c');
alter table t partition by list(to_char(i)) ( 
  partition p0 values in  ('a'),
   partition p1 values in  ('b'),
    partition p2 values in  ('c')
); 

drop table if exists t;
create table t(i char(10));
insert into t values ('a');
insert into t values ('b');
insert into t values ('c');
alter table t partition by range(to_char(i)) ( 
  partition p0 values less than  ('ddddddd')
 ); 
 drop table t;
