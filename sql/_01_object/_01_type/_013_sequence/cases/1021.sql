-- create table with SEQUENCE data type and insert Collections data


CREATE CLASS t1(
   col1       SEQUENCE
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;