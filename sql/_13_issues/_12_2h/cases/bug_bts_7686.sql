--TEST: [Function Based Index] Function Based Index doesn't work well when rename the table



create table t1 (a varchar(10), b varchar(10));
--create a index with fully qualified name
create index i_upper_b on t1 (upper(t1.b));
insert into t1 values ('a', 'a'), ('b', 'b');

--test: i_upper_b is used. this is good result.
select /*+ recompile */ * from t1 where upper(b)='A' using index i_upper_b;

--test: after rename t1 to t2, i_upper_b index is not correct in t2 table.
rename t1 to t2;
select /*+ recompile */ * from t2 where upper(b)='A' using index i_upper_b;

--rename table again
rename t2 to b;
select /*+ recompile */ * from b where upper(b)='B';

--change column name
alter table b change b ddd char(10);
select /*+ recompile */ * from b where upper(ddd)='A';


drop table b;


