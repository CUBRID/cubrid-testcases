-- [er]test definition MULTISET type column with invalid use of keyword 'SHARED'(like 'NOT NULL SHARED UNIQUE') in create statement 

CREATE CLASS ddl_0001(
    col1    MULTISET NOT NULL SHARED UNIQUE
);

drop ddl_0001;
