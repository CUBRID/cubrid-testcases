;auto off
-- (1) normal
create table parent (a int primary key);
create table child (a int foreign key references parent(a) on delete CASCADE);
insert into parent values(3);
insert into child values(3);
commit;
truncate parent cascade;
select count(*) from parent;
select count(*) from child;
rollback;
select count(*) from parent;
select count(*) from child;
drop child;
drop parent;
commit;

-- (2) inheritance case 1
create table obj_parent (z int);
create table parent under obj_parent;
alter table parent add column a int primary key;
create table child (a int foreign key references parent(a) on delete CASCADE);
insert into parent (a) values(3);
insert into child values(3);
commit;
truncate parent cascade;
select count(*) from parent;
select count(*) from child;
rollback;
select count(*) from parent;
select count(*) from child;
drop child;
drop parent;
drop table obj_parent;
commit;

-- (3) inheritance case 2
create table obj_parent (z int);
create table parent (a int primary key);
create table child under obj_parent;
alter table child add column a int foreign key references parent(a) on delete CASCADE;
insert into parent(a) values(3);
insert into child values(3, 3);
commit;
truncate parent cascade;
select count(*) from parent;
select count(*) from child;
rollback;
select count(*) from parent;
select count(*) from child;
drop child;
drop parent;
drop obj_parent;
commit;

-- (4) partitioning case 1
create table parent (a int primary key) partition by hash(a) partitions 2;
create table child (a int foreign key references parent(a) on delete CASCADE);
insert into parent values(3), (4);
insert into child values(3), (4);
commit;
truncate parent cascade;
select count(*) from parent;
select count(*) from child;
rollback;
select count(*) from parent;
select count(*) from child;
drop child;
drop parent;
commit;

-- (5) partitioning case 2
create table parent (a int primary key);
create table child (a int foreign key references parent(a) on delete CASCADE) partition by hash(a) partitions 2;
insert into parent values(3), (4);
insert into child values(3), (4);
commit;
truncate parent cascade;
select count(*) from parent;
select count(*) from child;
rollback;
select count(*) from parent;
select count(*) from child;
drop child;
drop parent;
commit;

-- (6) Mix of dont_reuse_oid and reuse_oid case 1
create table parent (a int primary key) reuse_oid;
create table child (a int foreign key references parent(a) on delete CASCADE) dont_reuse_oid;
insert into parent values(3);
insert into child values(3);
commit;
truncate parent cascade;
select count(*) from parent;
select count(*) from child;
rollback;
select count(*) from parent;
select count(*) from child;
drop child;
drop parent;
commit;

-- (7) Mix of dont_reuse_oid and reuse_oid case 2
create table parent (a int primary key) dont_reuse_oid;
create table child (a int foreign key references parent(a) on delete CASCADE) reuse_oid;
insert into parent values(3);
insert into child values(3);
commit;
truncate parent cascade;
select count(*) from parent;
select count(*) from child;
rollback;
select count(*) from parent;
select count(*) from child;
drop child;
drop parent;
commit;
