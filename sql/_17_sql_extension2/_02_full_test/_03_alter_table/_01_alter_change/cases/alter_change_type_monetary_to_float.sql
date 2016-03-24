--+ holdcas on;
--alter_table_change_type_strict
--change the type of a monetary column to float

create class coo(
        col1 monetary,
        col2 monetary,
        col3 monetary,
        col4 monetary
);

insert into coo
 values(73553.43, 12463343574.45, 839321123438.1232, -23452343516789044.92837);


show columns in coo;
select * from coo order by 1;


--monetary -> float, no loss of data
alter table coo change col1 col1 float;
select * from coo order by 1;

--monetary -> float, loss of data occurs, min(float) < monetary < max(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 float;
select * from coo order by 1;

--monetary -> float
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 float;
select * from coo order by 1;

--monetary -> float
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 float;
select * from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
