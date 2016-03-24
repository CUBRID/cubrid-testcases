--[er]It tests the case that one table inherit a field which is the same as the super tables and a table have two columns have the same name but different data types

CREATE TABLE ddl_0001 (
 col1 int,
 col2 char(10)
);
CREATE TABLE ddl_0002 (
 col1 int,
 col2 char(10)
);

CREATE TABLE ddl_0003 UNDER ddl_0001 (
 col1 int
);
CREATE TABLE ddl_0004 UNDER ddl_0003 (
 col1 int
);
CREATE TABLE ddl_0005 UNDER ddl_0004 (
 col1 int
);

CREATE TABLE ddl_0006 UNDER ddl_0002 (
 col1 int
);
CREATE TABLE ddl_0007 UNDER ddl_0006 (
 col1 int
);
CREATE TABLE ddl_0008 UNDER ddl_0007 (
 col1 int
);

CREATE TABLE ddl_0009 (
 col1 set of int ,
 col2 multiset of int,
 col1 list of int
);

CREATE TABLE ddl_000a (
 col1 int,
 col2 char(10)
);
CREATE TABLE ddl_000b (
 col1 int,
 col2 char(10)
);





drop class ddl_0001;
drop class ddl_0002;
drop class ddl_0003;
drop class ddl_0004;
drop class ddl_0005;
drop class ddl_0006;
drop class ddl_0007;
drop class ddl_0008;
drop class ddl_0009;
drop class ddl_000a;
drop class ddl_000b;