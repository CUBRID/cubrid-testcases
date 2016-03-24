-- create class with MULTISET type and insert data
CREATE CLASS ddl_0001(
    col1    MULTISET 
);

insert into ddl_0001 values({'a'});
insert into ddl_0001 values(null);

drop ddl_0001;

