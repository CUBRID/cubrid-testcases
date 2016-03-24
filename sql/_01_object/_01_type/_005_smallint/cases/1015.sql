-- [er]create table with smallint data type and  tests a create syntax with smallint data type and another constraint like 'DEFAULT 1 NOT NULL SHARED UNIQUE' then report Syntax error

CREATE CLASS ddl_0001(
    col1    smallint DEFAULT 1 NOT NULL SHARED UNIQUE
);





drop ddl_0001;