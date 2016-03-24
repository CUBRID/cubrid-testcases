-- [er]create table with DOUBLE data type and insert Collections data


CREATE CLASS t1(
   col1       DOUBLE
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;