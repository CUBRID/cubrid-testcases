--+ holdcas on;
--alter_table_change_type_strict
--change the type of a monetary column to nchar varying

create class coo(
        col1 monetary,
        col2 monetary,
        col3 monetary
);

insert into coo
 values(7382.23, -1234523456, -2112354.32);


show columns in coo;
select * from coo order by 1;


--monetary -> nchar varying, old prec < new prec
alter table coo change col1 col1 nchar varying(10);
select col1 from coo order by 1;

--monetary -> nchar varying, new prec = -1
alter table coo change col2 col2 nchar varying;
select col2 from coo order by 1;

--monetary -> nchar varying, new prec < old prec
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 nchar varying(8);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 nchar varying(8);
select col3 from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
