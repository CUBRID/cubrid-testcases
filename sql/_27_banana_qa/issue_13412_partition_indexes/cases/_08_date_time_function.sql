drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3 INT NOT NULL,
    col4 INT NOT NULL,
    PRIMARY KEY(col1, col3),
    UNIQUE KEY(col2)
)
PARTITION BY HASH( YEAR(col2) )
PARTITIONS 4;
drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3 INT NOT NULL,
    col4 INT NOT NULL,
    PRIMARY KEY(col1, col2,col3),
    UNIQUE KEY(col2)
)
PARTITION BY HASH( YEAR(col2) )
PARTITIONS 4;
drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3 INT NOT NULL,
    col4 INT NOT NULL,
    PRIMARY KEY(col1, col2,col3),
    UNIQUE KEY(col2)
)
PARTITION BY HASH( weekday(col2) )
PARTITIONS 4;
drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 INT NOT NULL,
    PRIMARY KEY(col1, col2,col3),
    UNIQUE KEY(col2)
)
PARTITION BY HASH( week(col2) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 INT NOT NULL,
    PRIMARY KEY(col1, col2,col3),
    UNIQUE KEY(col2,col3)
)
PARTITION BY HASH( week(col3) )
PARTITIONS 4;
drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 INT NOT NULL,
    PRIMARY KEY(col1, col2,col3),
    UNIQUE KEY(col2,col3)
)
PARTITION BY HASH( unix_timestamp(col2) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 INT NOT NULL,
    PRIMARY KEY(col1, col2,col3),
    UNIQUE KEY(col2,col3)
)
PARTITION BY HASH( timestamp(col2) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3)
)
PARTITION BY HASH( time_to_sec(col4) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3)
)
PARTITION BY HASH( time(col4) )
PARTITIONS 4;
drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3)
)
PARTITION BY HASH( second(col4) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( sec_to_time(col1) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( quarter(col3) )
PARTITIONS 4;
drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( month(col2) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( minute(col4) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( hour(col4) )
PARTITIONS 4;
drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( from_unixtime(col1) )
PARTITIONS 4;
drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( from_days(col1) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( dayofyear(col2) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( dayofweek(col2) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( day(col2) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( dayofmonth(col2) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3  timestamp NOT NULL,
    col4 time NOT NULL,
    PRIMARY KEY(col1, col2,col3,col4),
    UNIQUE KEY(col4,col2,col3,col1)
)
PARTITION BY HASH( date(col2) )
PARTITIONS 4;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3 INT NOT NULL,
    col4 INT NOT NULL,

  UNIQUE KEY(col2)
)
PARTITION BY HASH( YEAR(col2) )
PARTITIONS 4;
drop t6;

drop table if exists t6;
CREATE TABLE t6 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3 INT NOT NULL,
    col4 INT NOT NULL,

  primary  KEY(col4,col2)
)
PARTITION BY HASH( YEAR(col2) )
PARTITIONS 4;
drop t6;

drop table if exists t8;
CREATE TABLE t8 (
    col1 INT NOT NULL,
    col2 DATE NOT NULL,
    col3 INT NOT NULL,
    col4 INT NOT NULL,
    PRIMARY KEY(col1, col2, col4),
    UNIQUE KEY(col2, col1)
)
PARTITION BY HASH(YEAR(col2))
PARTITIONS 4;
drop t8;


drop table if exists t_no_pk;
 CREATE TABLE t_no_pk (c1 INT, c2 INT)
   PARTITION BY RANGE(c1) (
     PARTITION p0 VALUES LESS THAN (10),
     PARTITION p1 VALUES LESS THAN (20),
     PARTITION p2 VALUES LESS THAN (30),
     PARTITION p3 VALUES LESS THAN (40)
   );
   ALTER TABLE t_no_pk ADD PRIMARY KEY(c1);
ALTER TABLE t_no_pk DROP PRIMARY KEY;
ALTER TABLE t_no_pk ADD PRIMARY KEY(c1, c2);
ALTER TABLE t_no_pk DROP PRIMARY KEY;
 ALTER TABLE t_no_pk ADD PRIMARY KEY(c2);
drop table t_no_pk;

drop table if exists np_pk;
CREATE TABLE np_pk (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50),
    added DATE,
     PRIMARY KEY (id)
 );
ALTER TABLE np_pk
    PARTITION BY HASH( TO_DAYS(added) )
    PARTITIONS 4;
ALTER TABLE np_pk
    PARTITION BY HASH(id)
   PARTITIONS 4;
drop np_pk;

drop table if exists stuff;
CREATE TABLE stuff (id INT AUTO_INCREMENT, d DATE, PRIMARY KEY (id, d))
PARTITION BY RANGE(to_days(d)) (PARTITION p0 VALUES LESS THAN (733332), PARTITION p1 VALUES LESS THAN MAXVALUE);
drop stuff;

drop table if exists whatever;
create table whatever(key1 int,key2 int,primary key(key1,key2)) partition by range(key1) (partition p0 values less than (10),partition p1 values less than (20));
ALTER TABLE whatever
DROP PRIMARY KEY, 
ADD PRIMARY KEY (`key1`, `key2`), 
ADD UNIQUE INDEX `key1_UNIQUE` (`key1` ASC);
drop  whatever;

drop table if exists t;
CREATE TABLE t (c FLOAT) PARTITION BY LIST( FLOOR(c) )(
    PARTITION p0 VALUES IN (1,3,5),
     PARTITION p1 VALUES IN (2,4,6)
 );

drop table if exists t;
CREATE TABLE t (c FLOAT) PARTITION BY LIST( c )(
    PARTITION p0 VALUES IN (1,3,5),
     PARTITION p1 VALUES IN (2,4,6)
 );

drop table if exists t;
CREATE TABLE t (c double) PARTITION BY LIST( c )(
    PARTITION p0 VALUES IN (1.0,3.0,5.0),
     PARTITION p1 VALUES IN (2.0,4.0,6.0)
 );
drop table if exists t;
