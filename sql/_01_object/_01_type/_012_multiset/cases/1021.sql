-- create table with MULTISET data type and insert Collections data


CREATE CLASS t1(
   col1       MULTISET
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;