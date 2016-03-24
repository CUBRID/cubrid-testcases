--+ holdcas on;
--alter_table_change_type_strict
--change the type of a numeric column to short

create class coo(
        col1 numeric(4),
        col2 numeric(5),
        col3 numeric(5),
        col4 numeric(6),
        col5 numeric(7),
        col6 numeric(6, 3),
        col7 numeric(10, 4),
        col8 numeric(10, 4)
);

insert into coo
 values(7382, 12345, -21123, 516789, -6603438, 345.123, 654321.1234, -736283.5342);


show columns in coo;


--numeric -> short, old prec < 5, scale=0
alter table coo change col1 col1 short;
select col1 from coo order by 1;

--numeric -> short, old prec >= 5, scal=0, numeric < max(int)
alter table coo change col2 col2 short;
select col2 from coo order by 1;
--numeric -> short, old prec >= 5, scal=0, numeric > min(int)
alter table coo change col3 col3 short;
select col3 from coo order by 1;

--numeric -> short, old prec >= 5, scal=0, numeric > max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 short;
select col4 from coo order by 1;

--numeric -> short, old prec >= 5, scal=0, numeric < min(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 short;
select col5 from coo order by 1;

--numeric -> short, scal > 0, min(int) < numeric < max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 short;
select col6 from coo order by 1;

--numeric -> short, scal > 0, numeric > max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 short;
select col7 from coo order by 1;

--numeric -> short, scal > 0, numeric < min(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col8 col8 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col8 col8 short;
select col8 from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
