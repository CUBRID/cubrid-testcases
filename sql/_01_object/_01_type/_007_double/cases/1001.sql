--test creating table with double type and many keywords(like default, not null, unique, shard)
CREATE CLASS ddl_0001(
   col1		DOUBLE,
   col2		DOUBLE NOT NULL,
   col3		DOUBLE DEFAULT 1,   
   col4		DOUBLE DEFAULT 2 NOT NULL,
   col5		DOUBLE UNIQUE,
   col6		DOUBLE DEFAULT 10 UNIQUE,
   col7		DOUBLE UNIQUE NOT NULL,
   col8		DOUBLE DEFAULT 10 UNIQUE NOT NULL,
   col9		DOUBLE SHARED NULL,
   col10	DOUBLE SHARED 3.14 NOT NULL
);

drop ddl_0001;
