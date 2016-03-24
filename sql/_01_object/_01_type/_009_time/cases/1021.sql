-- [er]create table with TIME data type and insert Collections data


CREATE CLASS t1(
   col1       TIME
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;