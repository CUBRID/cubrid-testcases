-- [er]create table with timestamp data type and insert Collections data


CREATE CLASS t1(
   col1       timestamp
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;