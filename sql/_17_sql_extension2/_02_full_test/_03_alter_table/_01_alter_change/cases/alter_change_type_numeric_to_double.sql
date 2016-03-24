--+ holdcas on;
--alter_table_change_type_strict
--change the type of a numeric column to double

create class coo(
        col1 numeric(13, 3),
        col2 numeric(18, 7)
);

insert into coo
 values(7384783821.223, 12345372642.1234567);


show columns in coo;

d
--numeric -> double, old prec <= 15, min(double) < numeric < max(double)
alter table coo change col1 col1 double;
select * from coo order by 1;

--numeric -> double, old prec > 15, min(double) < numeric < max(double)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 double;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 double;
select * from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
