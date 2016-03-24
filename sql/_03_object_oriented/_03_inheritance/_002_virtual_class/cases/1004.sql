-- [er]create vclass and add selfclass as a superclass
CREATE VCLASS ddl_0001 UNDER ddl_0001(
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

drop ddl_0001;