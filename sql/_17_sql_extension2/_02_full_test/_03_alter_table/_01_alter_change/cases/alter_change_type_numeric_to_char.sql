--+ holdcas on;
--alter_table_change_type_strict
--change the type of a numeric column to char

create class coo(
        col1 numeric(7, 3),
        col2 numeric(10),
        col3 numeric(10, 3)
);

insert into coo
 values(7382.234, -1234523456, -2112354.321);


show columns in coo;


--numeric -> char, old prec + 2 < new prec
alter table coo change col1 col1 char(10);
select * from coo order by 1;

--numeric -> char, old prec + 2 = new prec, scale = 0
alter table coo change col2 col2 char(12);
select * from coo order by 1;

--numeric -> char, new prec < old prec
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 char(8);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 char(8);
select * from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
