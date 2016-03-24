--TEST: SPACE doesn't work well in function index


drop table if exists t1;

create table t1(a char(7));
insert into t1 values ('1234567');


--test: will fail and throw "ERROR: No error message available."
create index i_t1_a2q on t1(space(a));
create index i1 on t1(space(10));
create index i2 on t1(a, space(100));
create index i3 on t1(a, space(a));


drop table t1;
