-- [er]create table with nchar VARYING data type of 2 length but insert data with 3 length


CREATE CLASS ddl_0001(
   col1       nchar VARYING(2)
);

INSERT INTO ddl_0001 VALUES (N'121');

drop ddl_0001;