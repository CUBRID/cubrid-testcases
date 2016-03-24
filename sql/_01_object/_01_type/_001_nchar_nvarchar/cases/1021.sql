-- [er]create table with nchar VARYING data type and insert Collections data


CREATE CLASS t1(
   col1       nchar VARYING(20)
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;