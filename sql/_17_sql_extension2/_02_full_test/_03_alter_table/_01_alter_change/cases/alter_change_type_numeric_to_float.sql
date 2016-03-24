--+ holdcas on;
--alter_table_change_type_strict
--change the type of a numeric column to float

create class coo(
        col1 numeric(6, 3),
        col2 numeric(12, 7)
);

insert into coo
 values(738.223, 12345.1234567);


show columns in coo;


--numeric -> float, old prec <= 7, min(float) < numeric < max(float)
alter table coo change col1 col1 float;
select col1 from coo order by 1;

--numeric -> float, old prec > 7, min(float) < numeric < max(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 float;
select col2 from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
