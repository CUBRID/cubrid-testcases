-- [er]create table with smallint data type and  tests a create syntax with conditions like 'smallint DEFAULT 1234567890 SHARED' and then report syntax error

CREATE CLASS ddl_0001(
    col1    smallint DEFAULT 1234567890 SHARED
);





drop ddl_0001;