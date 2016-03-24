-- [er]test definition SEQUENCE type column with invalid use of keyword 'SHARED'(like 'NOT NULL SHARED UNIQUE') in create statement 

CREATE CLASS ddl_0001(
    col1    SEQUENCE NOT NULL SHARED UNIQUE
);

drop ddl_0001;
