-- [er]test definition SEQUENCE type column with 'SHARED UNIQUE' in create statement 

CREATE CLASS ddl_0001(
    col1    SEQUENCE SHARED NULL UNIQUE
);


drop ddl_0001;

