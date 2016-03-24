-- [er]create table with smallint data type using out of bounds value and tests a create syntax with conditions like 'smallint DEFAULT 1234567890' and then report syntax error

CREATE CLASS ddl_0001(
    col1    smallint DEFAULT 1234567890
);





drop ddl_0001;