-- [er]create table with timestampltz data type and insert Collections data


CREATE CLASS t1(
   col1       timestampltz
);

INSERT INTO t1 VALUES ({'golf', 'handicap'});

drop t1;