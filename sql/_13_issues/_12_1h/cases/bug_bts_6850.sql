create table pt(i int,j int) partition by hash(i) partitions 3;
insert into pt select rownum,rownum from db_class limit 40;
create index idx on pt(i) where i>5;
select * from pt where i>5 using index idx order by 1,2;
drop pt;

create table pt(i int) partition by hash( i ) partitions 3;
insert into pt select rownum from db_class limit 40;
create index idx on pt( i ) where i>5;
select * from pt where i>5 using index idx order by 1;
drop pt;

create table pt(v varchar(10),j int) partition by list(v) (
partition p0 values in ('dbc'),
partition p1 values in ('abc'));
insert into pt values('abc',0),('dbc',1);
create index idx on pt(v) where v>'a';
select * from pt where v>'a' using index idx order by 1,2;
drop pt;

create table pt(d date,j int) partition by range(d) (
partition p0 values less than ('2000-1-1'),
partition p1 values less than maxvalue);
insert into pt values('2012-9-9',2),('1999-12-31',1);
create index idx on pt(d) where d<'2012-1-1';
select * from pt where d<'2012-1-1' using index idx order by 1,2;
drop pt;








