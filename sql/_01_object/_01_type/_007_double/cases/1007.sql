--[er]test definition double type column with 'SHARED UNIQUE' in create statement

CREATE CLASS ddl_0001(
    col1    double SHARED NULL UNIQUE
);


drop ddl_0001;
