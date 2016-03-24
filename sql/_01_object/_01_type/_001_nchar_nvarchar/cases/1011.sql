-- [er]create table with nchar and  nchar varying data type of default length but insert data with 2 length on nchar data type


CREATE CLASS ddl_0001(
   col1       nchar,
   col2       nchar varying
);

INSERT INTO ddl_0001 VALUES (N'12',N'121');

drop ddl_0001;