--[er]test definition double type column with the keywords default, not null, shared in create statement 
CREATE CLASS ddl_0001(
    col1    double DEFAULT 1 NOT NULL SHARED
);

drop ddl_0001;
