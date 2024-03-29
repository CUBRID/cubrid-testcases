-- This test case verify the CBRD-24502.
-- Unintentional statistics update may cuase incorrect statistics information, which can cuase slow queries and system failure.
-- Before statistics were updated during DDL.
-- After modified statistics update is done only with the 'UPDATE STATISTICS' command.
-- Even though statistics are not updated during DDL, table catalog information must be updated.

drop table if exists t;
create table t (col_a int, col_b int)
partition by list(col_a) (partition p0 values in (1),partition p1 values in (2));
insert into t values(1,1),(2,2),(2,3),(2,4);


-- create index
create index idx1 on t(col_a);
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

-- alter table
alter table t comment 'aa';
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

-- drop index
drop index idx1 on t;
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

-- add constraint
alter table t add constraint primary key (col_a,col_b);
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

--drop constraint
alter table t drop primary key;
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

-- add constraint
alter table t add constraint primary key (col_a,col_b);
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

-- alter table "add column"
alter table t add column col3 varchar(10) ;
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

-- alter table "alter column"
alter table t alter column col3 set default 'qa team' ;
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

-- alter table "modify"
alter table t modify col3 varchar(100) ;
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

-- alter table "drop column"
alter table t drop column col3 ;
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;

-- update statistics (only update statistics)
update statistics on t with fullscan;
show indexes from t;
show indexes from t__p__p0;
show indexes from t__p__p1;


drop table if exists t;
