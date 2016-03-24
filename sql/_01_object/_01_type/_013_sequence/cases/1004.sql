-- [er]test definition SEQUENCE type column with invalid use of keyword 'SHARED'(like 'DEFAULT 1 SHARED') in create statement 

CREATE CLASS ddl_0001(
    col1    SEQUENCE DEFAULT 1 SHARED
);

drop ddl_0001;