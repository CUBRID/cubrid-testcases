create table a (a int primary key, c int NULL) partition by hash(a) partitions 2;
create table b (a int NULL, b int primary key, foreign key (a) references a(a) on delete CASCADE) partition by hash(b) partitions 2;
create table c (c int primary key, b int NULL, foreign key (b) references b(b) on delete CASCADE) partition by hash(c) partitions 2;

insert into a values (0,0), (1,1), (2,2), (3,3);
insert into b values (0,0), (1,1), (2,2), (3,3);
insert into c values (0,0), (1,1), (2,2), (3,3);

alter table a add constraint foreign key (c) references c(c) on delete cascade;

truncate a cascade;
select count(*) from a;
select count(*) from b;
select count(*) from c;
drop a cascade constraints;
drop b cascade constraints;
drop c cascade constraints;
