--TEST:  [Function Based Index] Function Based Index name generated automatically is not unique


create table t1 (a int, b int, c int);
create index i_a_b_a on t1 (a, b, sqrt(a));
create index i_a_b_b on t1 (a, b, sqrt(b));
create index i_a_c on t1 (a, c, sqrt(c));
create index i_b_c on t1 (b, c, sqrt(b));
create index i_a_b_c on t1 (a, c, b, sqrt(c));
--[er]
create index i_a_c on t1(a, b, sqrt(c));

create table t2(a int, b int, c int);
create index i_a_b_a on t2 (a, b, sqrt(a));
create index i_a_b_b on t2 (a, b, sqrt(b));


show index in t1;
show index in t2;


drop table t1, t2;

