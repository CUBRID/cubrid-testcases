-- [er]create table with DATE data type and insert Collections data


CREATE CLASS t1(
   col1       DATE
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;