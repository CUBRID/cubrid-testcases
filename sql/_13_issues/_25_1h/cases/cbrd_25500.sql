-- This test verifies the following issue: CBRD-25500
-- Queries containing ORDERBY_NUM() should not raise an Invalid XASL error.

drop table if exists t1;
create table t1 (a int);
insert into t1 values (1), (2), (3), (4), (5);

-- limit query
select * from t1 order by a desc limit 1;

-- orderby_num query
select * from t1 order by a desc for orderby_num() <= 1;

drop table if exists t1;
