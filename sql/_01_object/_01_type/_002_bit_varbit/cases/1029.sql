-- [er]create table with BIT VARYING data type and insert Collections data


CREATE CLASS t1(
   col1       BIT VARYING(20)
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;