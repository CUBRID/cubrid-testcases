CREATE TABLE t (d int);

ALTER TABLE t change column d d int default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d double default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d float default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d string default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d bigint default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d smallint default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d varchar(100) default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d char(100) default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d varnchar(100) default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d nchar(100) default sys_date;
DESCRIBE t;

ALTER TABLE t change column d d time default sys_date;
DESCRIBE t;


ALTER TABLE t change column d d int default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d double default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d float default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d string default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d bigint default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d smallint default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d varchar(100) default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d char(100) default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d varnchar(100) default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d nchar(100) default sys_datetime;
DESCRIBE t;

ALTER TABLE t change column d d time default sys_datetime;
DESCRIBE t;



ALTER TABLE t change column d d int default sys_timestamp;
DESCRIBE t;

ALTER TABLE t change column d d double default sys_timestamp;
DESCRIBE t;

ALTER TABLE t change column d d float default sys_timestamp;
DESCRIBE t;

ALTER TABLE t change column d d string default sys_timestamp;
DESCRIBE t;

ALTER TABLE t change column d d bigint default sys_timestamp;
DESCRIBE t;

ALTER TABLE t change column d d smallint default sys_timestamp;
DESCRIBE t;

ALTER TABLE t change column d d varchar(100) default sys_timestamp;
DESCRIBE t;

ALTER TABLE t change column d d char(100) default sys_timestamp;
DESCRIBE t;

ALTER TABLE t change column d d varnchar(100) default sys_timestamp;
DESCRIBE t;

ALTER TABLE t change column d d nchar(100) default sys_timestamp;
DESCRIBE t;



ALTER TABLE t change column d d int default unix_timestamp();
DESCRIBE t;

ALTER TABLE t change column d d double default unix_timestamp();
DESCRIBE t;

ALTER TABLE t change column d d float default unix_timestamp();
DESCRIBE t;

ALTER TABLE t change column d d string default unix_timestamp();
DESCRIBE t;

ALTER TABLE t change column d d bigint default unix_timestamp();
DESCRIBE t;

ALTER TABLE t change column d d smallint default unix_timestamp();
DESCRIBE t;

ALTER TABLE t change column d d varchar(100) default unix_timestamp();
DESCRIBE t;

ALTER TABLE t change column d d char(100) default unix_timestamp();
DESCRIBE t;

ALTER TABLE t change column d d varnchar(100) default unix_timestamp();
DESCRIBE t;

ALTER TABLE t change column d d nchar(100) default unix_timestamp();
DESCRIBE t;




ALTER TABLE t change column d d int default user();
DESCRIBE t;

ALTER TABLE t change column d d double default user();
DESCRIBE t;

ALTER TABLE t change column d d float default user();
DESCRIBE t;

ALTER TABLE t change column d d bigint default user();
DESCRIBE t;

ALTER TABLE t change column d d smallint default user();
DESCRIBE t;

ALTER TABLE t change column d d time default user();
DESCRIBE t;


-- tst for type inconsistency - current_user()

ALTER TABLE t change column d d int default current_user;
DESCRIBE t;

ALTER TABLE t change column d d double default current_user;
DESCRIBE t;

ALTER TABLE t change column d d float default current_user;
DESCRIBE t;

ALTER TABLE t change column d d bigint default current_user;
DESCRIBE t;

ALTER TABLE t change column d d smallint default current_user;
DESCRIBE t;

ALTER TABLE t change column d d time default current_user;
DESCRIBE t;


DROP TABLE t;



