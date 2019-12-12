drop table if exists foo,woo;

CREATE TABLE FOO (C1 INT COMMENT 'foo.c1 is base column') COMMENT 'foo is base table';
CREATE TABLE WOO LIKE FOO;

SELECT CLASS_NAME, COMMENT FROM DB_CLASS WHERE CLASS_NAME = 'foo' OR CLASS_NAME = 'woo' order by 1,2;
SELECT ATTR_NAME, COMMENT FROM DB_ATTRIBUTE WHERE CLASS_NAME = 'foo' OR CLASS_NAME = 'woo' order by 1,2;

show create table foo;
show create table woo;

drop table if exists foo,woo;
