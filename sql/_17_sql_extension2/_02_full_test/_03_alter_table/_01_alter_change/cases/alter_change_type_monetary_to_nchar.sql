--+ holdcas on;
--alter_table_change_type_strict
--change the type of a monetary column to nchar

create class coo(
        col1 monetary,
        col2 monetary,
        col3 monetary
);

insert into coo
 values(7382.23, -1234523, -2112354.32);


show columns in coo;
select * from coo order by 1;


--monetary -> nchar, old prec < new prec
alter table coo change col1 col1 nchar(10);
select col1 from coo order by 1;

--monetary -> nchar
alter table coo change col2 col2 nchar(9);
select col2 from coo order by 1;

--monetary -> nchar, new prec < old prec
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 nchar(6);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 nchar(6);
select col3 from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
