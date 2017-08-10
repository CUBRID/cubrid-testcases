---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- changing default
-- DEFAULT value should be ignored

-- no default at creation
create class c1 class attribute (c_i integer)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=-1;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i c_i integer default 5;

insert into c1 set i=3;

select class c1.c_i, i from c1 order by 1,2;

show columns in c1;

drop class c1;


-- with default at creation + change
create class c1 class attribute (c_i integer default 10)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=20;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i c_i integer default 5;

insert into c1 set i=3;

select class c1.c_i, i from c1 order by 1,2;

show columns in c1;

drop class c1;


-- with default at creation + no default after change + type change
create class c1 class attribute (c_i integer default 10)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=20;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i c_s varchar(10);

insert into c1 set i=3;

select class c1.c_s, i from c1 order by 1,2;

show columns in c1;

drop class c1;


-- with default at creation + type change 1
create class c1 class attribute (c_i short default 10)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=-1;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i c_b bigint default 1000000;

insert into c1 set i=3;

select class c1.c_b, i from c1 order by 1,2;

show columns in c1;

drop class c1;


-- with default at creation + type change 2
create class c1 class attribute (c_s char(10) default '10')  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_s='20';

select class c1.c_s, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_s c_i int default -4;

insert into c1 set i=3;

select class c1.c_i, i from c1 order by 1,2;

show columns in c1;

drop class c1;

-- with default at creation + type change 3
create class c1 class attribute (c_s char(2) default '10')  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_s='20';

select class c1.c_s, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_s c_i int default -4;

insert into c1 set i=3;

select class c1.c_i, i from c1 order by 1,2;

show columns in c1;

drop class c1;