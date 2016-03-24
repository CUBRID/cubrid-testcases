-- [er]create table with timestamptz data type and insert Collections data


CREATE CLASS t1(
   col1       timestamptz
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;