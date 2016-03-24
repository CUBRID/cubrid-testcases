-- [er]test definition MULTISET type column with invalid use of keyword 'SHARED'(like 'DEFAULT 1 SHARED UNIQUE') in create statement 

CREATE CLASS ddl_0001(
    col1    MULTISET DEFAULT 1 SHARED UNIQUE
);

drop ddl_0001;
