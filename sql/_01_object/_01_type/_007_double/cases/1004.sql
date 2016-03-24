-- [er]test definition double type column with the keywords default, shared, unique in create statement
CREATE CLASS ddl_0001(
    col1    double DEFAULT 1 SHARED UNIQUE
);

drop ddl_0001;
