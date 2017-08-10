create table type_info
(a1 SHORT, a2 SMALLINT,
b1 INT, b2 INTEGER,
c1 BIGINT,
d1 NUMERIC, d2  NUMERIC(10, 1), d3 DECIMAL,
f FLOAT, f2 REAL,
g DOUBLE, 
h MONETARY,
i DATE, j TIME, k TIMESTAMP, l DATETIME,
m1 BIT, m2 BIT(10), 
n1 BIT VARYING, n2 BIT VARYING(12),
o1 CHAR, o2 CHAR(10),
p1 VARCHAR, p2 VARCHAR(20),
q STRING,
r1 NCHAR, r2 NCHAR(30),
s1 NCHAR VARYING(40),
t1 BLOB, t2 CLOB
);  
show columns from type_info;

create table type1 (a varchar(10));
show columns from type1;

create table type2 (a bit varying(10));
show columns from type2;

create table type3 (a nchar varying(10));
show columns from type3;

create table type4( a string);
show columns from type4;
drop type_info;
drop type1;
drop type2;
drop type3;
drop type4;
