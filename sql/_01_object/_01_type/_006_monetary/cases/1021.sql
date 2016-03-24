-- [er]create table with monetary data type and insert Collections data


CREATE CLASS t1(
   col1       monetary
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;