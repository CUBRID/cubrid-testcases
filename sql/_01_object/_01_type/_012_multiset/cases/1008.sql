-- [er]test definition MULTISET type column with 'SHARED UNIQUE' in create statement 

CREATE CLASS ddl_0001(
    col1    MULTISET SHARED NULL UNIQUE
);


drop ddl_0001;

