-- [er]test definition double type column with 'DEFAULT 1 NOT NULL SHARED UNIQUE' in create statement

CREATE CLASS ddl_0001(
    col1    double DEFAULT 1 NOT NULL SHARED UNIQUE
);

drop ddl_0001;
