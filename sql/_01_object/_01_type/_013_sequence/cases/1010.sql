--[er]insert data into SEQUENCE column with unmatched TYPE
CREATE CLASS ddl_0001(
    col1    SEQUENCE(integer)
);

insert into ddl_0001 values({'a'});

drop ddl_0001;

