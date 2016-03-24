create table t1(a int,b char(1000), c varchar(1000), d date);
create index idx on t1(a)where c > 'A' and b > 'A';
create index idx on t1(a,d)where c > 'A' and b > 'A';
create index idx1 on t1(a,b)where c > 'A' and b > 'A';
create index idx2 on t1(a,c)where c > 'A' and b > 'A';
drop table t1;

create table t1(a int not null,b char(1000), c varchar(1000), d date);
create index idx on t1(d)where c > 'A' and b > 'A';
create index idx on t1(a)where c > 'A' and b > 'A';
create index idx1 on t1(a,d)where c > 'A' and b > 'A';
drop table t1;
