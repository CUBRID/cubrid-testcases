-- [er]create table with nchar and  nchar varying data type of 0 or -1



CREATE CLASS ddl_0001(
   col1       nchar(0),
   col2       nchar varying(0) ,
   col3       nchar(-1),
   col4       nchar varying(-1) 
);

drop ddl_0001;