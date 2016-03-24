-- SHOW CREATE VIEW

create table t1 (i1 integer);
create table t2 (i2 integer);
create table t4 (i4 integer);

create class c1 (i1 integer);


create view v1 as select i1 from t1;
create view v2 as select * from t2;
create view v4 (i integer) as select i4 from t4;


create view vc1 as select * from c1;

create view vv1 as select * from v1;

-- should fail
show create view t1;

-- should fail
show create view 'v1';

show create view `v1`;

show create view v1;

show create view v2;


show create view v4;

show create view vc1;

show create view vv1;



drop view vv1;

drop view v1;

drop view v2;

drop view v4;

drop view vc1;

drop class c1;

drop table t1;
drop table t2;
drop table t4;

