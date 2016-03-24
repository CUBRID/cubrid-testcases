--create table with smallint data type and tests a create syntax with smallint data type and another constraint like unique,not null, shared and set default value

CREATE CLASS ddl_0001(
   col1       smallint,
   col2       smallint DEFAULT 1,
   col3       smallint NOT NULL,
   col4       smallint DEFAULT 2 NOT NULL,
   col5       smallint DEFAULT 2,
   col6       smallint UNIQUE,
   col7       smallint UNIQUE NOT NULL,
   col8       smallint SHARED NULL,
   col9       smallint SHARED 1 NOT NULL
);






drop ddl_0001;
