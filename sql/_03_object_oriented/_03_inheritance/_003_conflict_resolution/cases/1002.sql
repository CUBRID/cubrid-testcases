-- [er]create VCLASS and another VCLASS with same attribute but different type inherited from the created VCLASS

CREATE VCLASS ddl_0001(
 col1  integer ,
 col2  numeric(10,5) ,
 col3  varchar(123456789) default 'ddl_0001',
 col4  char(100000),
 col5  float,
 col6  double,
 col7  bit(1000),
 col8  date,
 col9  time,
 col10  timestamp
);

CREATE VCLASS ddl_0002 UNDER ddl_0001(
 col1  varchar(123456789) ,
 col12  int ,
 col13  char(1000) default 'ddl_0002',
 col14  double,
 col15  date,
 col16  bit(1000),
 col17  timestamp,
 col18  time,
 col19  char(100000),
 col20  float
);

drop VCLASS ddl_0001;
drop VCLASS ddl_0002;