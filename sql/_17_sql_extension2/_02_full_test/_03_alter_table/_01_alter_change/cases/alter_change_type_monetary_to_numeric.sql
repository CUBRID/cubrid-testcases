--+ holdcas on;
--alter_table_change_type_strict
--change the type of a monetary column to numeric

create class coo(
        col1 monetary,
        col2 monetary,
        col3 monetary,
        col4 monetary
);

insert into coo
 values(73553.43, 1246.45, 839321123438.1232, -23789044.9285);


show columns in coo;
select * from coo order by 1;


--monetary -> numeric,
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col1 col1 numeric(6, 3);
select col1 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col1 col1 numeric(6, 3);
select col1 from coo order by 1;

--monetary -> numeric(), loss of data occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 numeric(10);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 numeric(10);
select col2 from coo order by 1;

--monetary -> numeric
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 numeric(8, 1);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 numeric(8, 1);
select col3 from coo order by 1;

--monetary -> numeric
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 numeric(7, 6);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 numeric(7, 6);
select col4 from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
