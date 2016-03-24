-- [er]create table with nchar and  nchar varying data type of 536870912



CREATE CLASS ddl_0001(
   col1       nchar(536870912),
   col2       nchar varying(536870912) 
);

drop ddl_0001;