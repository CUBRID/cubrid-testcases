--[er]insert data into set column with unmatched TYPE
CREATE CLASS ddl_0001(
    col1    SET(integer)
);

insert into ddl_0001 values({'a'});

drop ddl_0001;

