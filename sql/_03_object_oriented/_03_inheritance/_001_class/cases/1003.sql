--[er]create two tables ddl_001 and ddl_0002 then create another table inherited from the two tables,only inherite a few specified columns,one  of the column is wrong because of not existing error  

CREATE CLASS ddl_0001(
 col1    int Unique Not Null,
 col2    varchar(100),
 col3    varchar(100),
 colCreateTm    timestamp Not Null);

CREATE CLASS ddl_0002(
 col1    int Unique Not Null,
 col2    varchar(100),
 col3    varchar(100),
 colCreateTm    timestamp Not Null);

-- Inherit Error
CREATE CLASS ddl_0003 UNDER ddl_0001, ddl_0002(
 col4    varchar(100),
 col5    varchar(100)
)
Inherit coL1 Of ddl_0001 AS ddl_0001_col1,
 cOl2 Of ddl_0001 As ddl_0001_col2,
 Col3 Of ddl_0001 As ddl_0001_col3,
 COLCreateTm Of ddl_0054 As ddl_0001_colCreateTm;





drop class ddl_0001;
drop class ddl_0002;
drop class ddl_0003;
