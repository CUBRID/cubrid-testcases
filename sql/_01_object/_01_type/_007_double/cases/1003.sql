-- [er]test definition double type column with the keywords default, shared in create statement
CREATE CLASS ddl_0001(
    col1    double DEFAULT 1 SHARED
);

drop ddl_0001;
