select if (abs(UTC_DATE() - SYS_DATE) <= 1, 'ok','nok');


CREATE VIEW v1(utcdate) as select utc_date() from db_root;

SELECT * from db_vclass where vclass_name='v1';

SELECT if(abs(utcdate-SYS_DATE) <= 1, 'ok','nok') FROM v1;

DROP VIEW v1;

CREATE TABLE t1 as select UTC_DATE() from db_root;

SELECT * FROM db_attribute where class_name='t1';

DROP TABLE t1;

CREATE TABLE t1 (utcdate date);

INSERT INTO t1(utcdate) values(utc_date());

SELECT if (abs(utcdate - SYS_DATE) <=1,'ok','nok') FROM t1;

DROP TABLE t1;

-- should fail : wrong number of params
select utc_date(1);