-- [er]create table with bit data type and insert Collections data


CREATE CLASS t1(
   col1       bit(20)
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;