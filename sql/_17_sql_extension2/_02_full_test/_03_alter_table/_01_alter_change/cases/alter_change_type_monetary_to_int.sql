--+ holdcas on;
--alter_table_change_type_strict
--change the type of a monetary column to int

create class coo(
        col1 monetary,
        col2 monetary,
        col3 monetary,
        col4 monetary
);

insert into coo
 values(7355343, 12343574.45, 839321123438.1232, -23452343516789044);


show columns in coo;
select * from coo order by 1;


--monetary -> int, no loss of data
alter table coo change col1 col1 int;
select * from coo order by 1;

--monetary -> int, loss of data occurs, min(int) < monetary < max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 int;
select * from coo order by 1;

--monetary -> int, monetary > max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 int;
select * from coo order by 1;

--monetary -> int, monetary < min(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 int;
select * from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
