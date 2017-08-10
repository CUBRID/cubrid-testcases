-- SHOW COLUMNS -- all types + default values
create table tt1( dt DATETIME, 
		  b BIGINT,
		  vnc1 National CHAR varying,
		  vnc2 National CHAR varying(10),
		  nc1 National CHAR,
		  nc2 National CHAR(10),
		  c1 CHAR,
		  c2 CHAR(10),
		  vb1 BIT VARYING,
		  vb2 BIT VARYING(10),
		  b1 BIT,
		  b2 BIT(8),
		  n1 NUMERIC,
		  n2 NUMERIC(10),
		  n3 NUMERIC(10,2),
		  s SHORT,
		  m MONETARY,
		  d DATE,
		  ts TIMESTAMP,
		  t TIME,
		  sq SEQUENCE,
		  ms MULTISET,
		  st SET (integer),
		  o OBJECT,
		  vc1 CHAR varying,
		  vc2 CHAR varying(10),
		  db DOUBLE,
		  f FLOAT,
		  i1 INTEGER,
		  i2 integer auto_increment);
		  
show columns in tt1;

show columns from tt1;

		  
drop table tt1;

