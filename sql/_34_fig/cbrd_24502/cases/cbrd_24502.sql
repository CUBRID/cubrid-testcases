-- This test case verify the CBRD-24502.
-- Unintentional statistics update may cuase incorrect statistics information, which can cuase slow queries and system failure.
-- Before statistics were updated during DDL.
-- After modified statistics update is done only with the 'UPDATE STATISTICS' command.
-- Even though statistics are not updated during DDL, table catalog information must be updated.

drop table if exists t;
create table t (col_a int, col_b int);
insert into t values(1,1),(2,2),(2,3),(2,4);

-- create index
create index idx1 on t(col_a);
show indexes from t;

-- alter table
alter table t comment 'aa';
show indexes from t;

-- drop index
drop index idx1 on t;
show indexes from t;

-- add constraint
alter table t add constraint primary key (col_a,col_b);
show indexes from t;

--drop constraint
alter table t drop primary key;
show indexes from t;

-- add constraint
alter table t add constraint primary key (col_a,col_b);
show indexes from t;

-- update statistics (only update statistics)
update statistics on t with fullscan;
--describe t;
show indexes from t;


drop table if exists t;
