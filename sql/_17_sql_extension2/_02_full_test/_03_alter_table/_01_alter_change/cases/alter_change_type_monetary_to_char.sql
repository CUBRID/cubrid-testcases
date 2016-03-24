--+ holdcas on;
--alter_table_change_type_strict
--change the type of a monetary column to char

create class coo(
        col1 monetary,
        col2 monetary,
        col3 monetary
);

insert into coo
 values(7382.23, -121234523456, -232112354.321);


show columns in coo;
select * from coo order by 1;


--monetary -> char, old prec  < new prec
alter table coo change col1 col1 char(10);
select col1 from coo order by 1;

--monetary -> char, old prec = new prec, scale = 0
alter table coo change col2 col2 char(14);
select col2 from coo order by 1;

--monetary -> char, new prec < old prec
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 char(8);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 char(8);
select col3 from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
