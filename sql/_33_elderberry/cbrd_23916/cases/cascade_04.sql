create table a (a int primary key);

create table b (a int, b int primary key, constraint foreign key (a) references a(a) on delete cascade)
partition by range (b) (
    partition before_2 values less than (2),
    partition before_4 values less than (4)
);

create table c (c int, b int, constraint foreign key (b) references b(b) on delete cascade)
partition by range (c) (
    partition before_2 values less than (2),
    partition before_4 values less than (4)
);

insert into a values (3);
insert into b values (3, 1);
insert into b values (3, 3);
insert into c values (1, 3);
insert into c values (3, 3);

truncate a cascade;
select count(*) from a;
select count(*) from b;
select count(*) from c;
drop c;
drop b;
drop a;
