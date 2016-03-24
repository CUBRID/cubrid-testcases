--+ holdcas on;
--alter_table_change_type_strict
--change the type of a numeric column to monetary

create class coo(
        col1 numeric(6, 2),
        col2 numeric(12, 7)
);

insert into coo
 values(7382.23, 12345.1234567);


show columns in coo;


--numeric -> monetary, no data loss
alter table coo change col1 col1 monetary;
select * from coo order by 1;

--numeric -> monetary, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 monetary;
select * from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
