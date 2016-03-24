--+ holdcas on;
--alter_table_change_type_strict
--change the type of a monetary column to varchar

create class coo(
        col1 monetary,
        col2 monetary,
        col3 monetary
);

insert into coo
 values(7382.23, -12345.67, -2112354.32);


show columns in coo;
select * from coo order by 1;


--monetary -> varchar, old prec + 2 < new prec
alter table coo change col1 col1 varchar(10);
select * from coo order by 1;

--monetary -> varchar, new prec = -1
alter table coo change col2 col2 varchar;
select * from coo order by 1;

--monetary -> varchar, new prec < old prec
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 varchar(6);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 varchar(6);
select * from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
