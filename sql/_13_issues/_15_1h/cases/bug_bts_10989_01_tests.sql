set system parameters 'create_table_reuseoid=no';
-- setup
autocommit off;

create table t1 (i int, j int);
insert into t1 values (1, 1);

create table t2 (i int, j int);
insert into t2 values (3, 3);

create table u1 (j int, k int);
insert into u1 values (2, 2);

create table u2 (j int, k int);
insert into u2 values (4, 4);
commit;

create view vt1 as select * from t1;
create view vt2 as select * from t2;
create view vu1 as select * from u1;
create view vu2 as select * from u2;

create view vt as select * from (t1, t2);
create view vu as select * from u1;
alter view vu add query select * from u2;

create view vvt as select * from (vt1, vt2);
create view vvu as select * from vu1;
alter view vvu add query select * from vu2;

create view vvvt as select * from vvt;
create view vvvu as select * from vvu;
commit;

-- table spec set tests
update (t1, t2) set i = 123;
select * from (t1, t2);
rollback;

update (t1, u1) set i = 123;
rollback;

update (t1, u1) set j = 123;
select * from (t1, u1);
rollback;

update (t1, t2, u1, u2) set j = 123;
select * from (t1, t2, u1, u2);
rollback;

-- view spec set tests
update (vt1, vt2) set i = 123;
select * from (vt1, vt2);
rollback;

update (vt1, vu1) set i = 123;
rollback;

-- mixed spec set tests
update (vt1, t2) set i = 123;
select * from (vt1, t2);
rollback;

update (t1, vt2) set i = 123;
select * from (t1, vt2);
rollback;

update (t1, vu1) set i = 123;
rollback;

update (t1, vu1) set j = 123;
select * from (t1, vu1);
rollback;

-- nested spec sets
update vt set i = 123;
select * from vt;
rollback;

update vu set j = 123;
select * from vu;
rollback;

update vvt set i = 123;
select * from vvt;
rollback;

update vvu set j = 123;
select * from vvu;
rollback;

update vvvt set i = 123;
select * from vvvt;
rollback;

update vvvu set j = 123;
select * from vvvu;
rollback;

-- insert tests
insert into vt values (1, 2);
insert into vvt values (1, 2);
insert into vvvt values (1, 2);
insert into vu values (1, 2);
insert into vvu values (1, 2);
insert into vvvu values (1, 2);
rollback;

-- cleanup
drop t1, t2, u1, u2, vt1, vt2, vu1, vu2, vt, vu, vvt, vvu, vvvt, vvvu;
commit;

autocommit on;
commit;

set system parameters 'create_table_reuseoid=yes';
