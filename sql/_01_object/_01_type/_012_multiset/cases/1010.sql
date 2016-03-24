--[er]insert data into MULTISET column with unmatched TYPE
CREATE CLASS ddl_0001(
    col1    MULTISET(integer)
);

insert into ddl_0001 values({'a'});

drop ddl_0001;

