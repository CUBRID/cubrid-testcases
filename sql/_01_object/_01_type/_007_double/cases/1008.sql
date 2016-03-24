--test definition double type column with overflow value as default in create statement

CREATE CLASS ddl_0001(
    col1    double DEFAULT 1.7976931348623157e+1308
);

drop ddl_0001;
