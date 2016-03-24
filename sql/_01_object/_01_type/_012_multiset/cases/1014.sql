-- [er]create table with MULTISET data type and insert string data


CREATE CLASS t1(
   col1       MULTISET
);

INSERT INTO t1 VALUES ('a');

drop t1;