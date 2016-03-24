--+ holdcas on;
--alter_table_change_type_strict
--change the type of a monetary column to short

create class coo(
        col1 monetary,
        col2 monetary,
        col3 monetary,
        col4 monetary
);

insert into coo
 values(735, 123.45, 21123438.1232, -516789044);


show columns in coo;


--monetary -> short, no loss of data
alter table coo change col1 col1 short;
select * from coo order by 1;

--monetary -> short, loss of data occurs, min(short) < monetary < max(short)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 short;
select * from coo order by 1;


--monetary -> short, monetary > max(short)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 short;
select * from coo order by 1;

--monetary -> short, monetary < min(short)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 short;
select * from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
