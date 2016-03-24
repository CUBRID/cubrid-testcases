--TEST:  [Function Based Index] Unique Function Based Index doesn't work well when there is another PRIMARY KEY index on same column.


create table t1 (a int, b int);
--[er] unique function index is not allowecd
create unique index i_abs_a on t1(abs(a));
insert into t1 values (1,1);
insert into t1 values (-1,2);
--[er] 
create unique index i_t1_a on t1(floor(b));

create table t2(a int primary key, b int unique);
--[er]
create unique index i_t2_a on t2(round(a));
create unique index i_t2_b on t2(abs(b));


drop table t1, t2;

