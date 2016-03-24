-- [er]create table with NUMERIC data type and insert Collections data


CREATE CLASS t1(
   col1       NUMERIC
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;