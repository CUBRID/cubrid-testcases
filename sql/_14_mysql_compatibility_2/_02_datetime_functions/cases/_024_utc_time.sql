select if (abs(UTC_TIME() - SYS_TIME) <= 86400, 'ok','nok');


CREATE VIEW v1(utctime) as select utc_time() from db_root;

SELECT * from db_vclass where vclass_name='v1';

SELECT if(abs(utctime-SYS_TIME) <= 86400, 'ok','nok') FROM v1;

DROP VIEW v1;

CREATE TABLE t1 as select UTC_TIME() as [ utc_time() ] from db_root;

SELECT * FROM db_attribute where class_name='t1';

DROP TABLE t1;

CREATE TABLE t1 (utctime time);

INSERT INTO t1(utctime) values(utc_time());

SELECT if (abs(utctime - SYS_TIME) <= 86400,'ok','nok') FROM t1;

DROP TABLE t1;

-- should fail : wrong number of params
select utc_time(1);
