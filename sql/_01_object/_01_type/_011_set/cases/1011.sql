-- create class with SET type and insert data
CREATE CLASS ddl_0001(
    col1    SET 
);

insert into ddl_0001 values({'a'});
insert into ddl_0001 values(null);

drop ddl_0001;

