-- CASE 1 NOT share WITH unique
create table t11(i int primary key);
insert into t11 values(1),(2),(3);
create table t12(i int unique);
alter table t12 add constraint foreign key fk(i) references t11(i);
alter table t12 drop constraint u_t12_i;
insert into t12 values(1);
insert into t12 values(1);

SELECT * FROM t12;
drop t12;
drop t11;

-- CASE 2 NOT share WITH pk
create table t21(i int primary key);
insert into t21 values(1),(2),(3);
create table t22(i int primary key);
alter table t22 add constraint foreign key fk(i) references t21(i);
alter table t22 DROP PRIMARY KEY;
insert into t22 values(1);
insert into t22 values(1);

SELECT * FROM t22;
drop t22;
drop t21;

