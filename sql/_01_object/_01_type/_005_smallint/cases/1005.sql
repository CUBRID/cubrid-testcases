-- [er]create table, smallint data type with both default and shared and tests a create syntax with conditions like 'smallint DEFAULT 1234567890 NOT NULL SHARED' and then report syntax error like ' invalid use of keyword SHARED, expecting Right_Paren'

CREATE CLASS ddl_0001(
    col1    smallint DEFAULT 1234567890 NOT NULL SHARED
);





drop ddl_0001;