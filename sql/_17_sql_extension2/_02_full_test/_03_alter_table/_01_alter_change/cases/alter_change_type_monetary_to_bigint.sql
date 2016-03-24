--+ holdcas on;
--alter_table_change_type_strict
--change the type of a monetary column to bigint

create class coo(
        col1 monetary,
        col2 monetary,
        col3 monetary,
        col4 monetary
);

insert monetaryo coo
 values(73435344555343, 12889093343574.45, 9993211234388936909.1232, -9992345234351678904);


show columns in coo;


--monetary -> bigint, no loss of data
alter table coo change col1 col1 bigint;
select * from coo order by 1;

--monetary -> bigint, loss of data occurs, min(bigint) < monetary < max(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 bigint;

--monetary -> bigint, monetary > max(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 bigint;
select * from coo order by 1;

--monetary -> bigint, monetary < min(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 bigint;
select * from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
