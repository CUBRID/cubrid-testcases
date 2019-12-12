-- SHOW COLUMNS -- all types + default values
create table tt1( dt DATETIME default datetime'1999-10-11 10:11:12', 
		  b BIGINT default 1234567890123,
		  vnc1 National CHAR varying default n'vnc1',
		  vnc2 National CHAR varying(10) default n'vnc2',
		  nc1 National CHAR default n'c',
		  nc2 National CHAR(10) default n'nc2',
		  c1 CHAR default 'c',
		  c2 CHAR(10) default 'c2',
		  vb1 BIT VARYING default b'10',
		  vb2 BIT VARYING(10) default b'10',
		  b1 BIT default b'1',
		  b2 BIT(8) default b'10',
		  n1 NUMERIC default 10.1,
		  n2 NUMERIC(10) default 10.1,
		  n3 NUMERIC(10,2) default 10.1,
		  s SHORT default 10,
		  m MONETARY default 123,
		  d DATE default date'1999-03-04',
		  ts TIMESTAMP default timestamp '1999-10-11 10:11:12',
		  t TIME default time '10:11:12',
		  sq SEQUENCE , 
		  ms MULTISET,
		  st SET (integer) default {1},
		  o OBJECT,
		  vc1 CHAR varying default 'vc1' not null,
		  vc2 CHAR varying(10) default 'vc2',
		  db DOUBLE default 1.12e1,
		  f FLOAT default 1.2,
		  i1 INTEGER default 123,
		  i2 integer auto_increment not null);
		  

show columns from tt1;

		  
drop table tt1;

