-- [er]create table with MULTISET data type and insert nchar data


CREATE CLASS t1(
   col1       MULTISET 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;