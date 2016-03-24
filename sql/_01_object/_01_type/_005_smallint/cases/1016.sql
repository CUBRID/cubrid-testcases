-- [er]create table with smallint data type and tests a create syntax with conditions like 'smallint NOT NULL SHARED UNIQUE' and then report syntax error

CREATE CLASS ddl_0001(
    col1    smallint NOT NULL SHARED UNIQUE
);





drop ddl_0001;