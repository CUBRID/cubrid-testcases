--insert data into set column
CREATE CLASS ddl_0001(
    col1    SET(integer)
);

insert into ddl_0001 values({10});
select * from ddl_0001;

drop ddl_0001;

