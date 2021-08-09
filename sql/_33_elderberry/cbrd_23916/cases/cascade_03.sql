create table a (a int primary key, c int NULL);
create table b (a int NULL, b int primary key, foreign key (a) references a(a) on delete CASCADE);
create table c (c int primary key, b int NULL, foreign key (b) references b(b) on delete CASCADE);

insert into a values (3, 3);
insert into b values (3, 3);
insert into c values (3, 3);

alter table a add constraint foreign key (c) references c(c) on delete cascade;

truncate a cascade;
select count(*) from a;
select count(*) from b;
select count(*) from c;
drop a cascade constraints;
drop b cascade constraints;
drop c cascade constraints;
