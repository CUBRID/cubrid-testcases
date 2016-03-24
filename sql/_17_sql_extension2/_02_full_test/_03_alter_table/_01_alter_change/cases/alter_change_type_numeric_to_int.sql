--+ holdcas on;
--alter_table_change_type_strict
--change the type of a numeric column to int

create class coo(
        col1 numeric(7),
        col2 numeric(10),
        col3 numeric(10),
        col4 numeric(15),
        col5 numeric(13),
        col6 numeric(10, 3),
        col7 numeric(16, 4),
        col8 numeric(16, 4)
);

insert into coo
 values(7382234, 1234523456, -2112354321, 516789073928432, -6603438382912, 3457655.123, 654321829354.1234, -736283562934.5342);


show columns in coo;


--numeric -> int, old prec < 10, scale=0
alter table coo change col1 col1 int;
select col1 from coo order by 1;

--numeric -> int, old prec >= 10, scal=0, numeric < max(int)
alter table coo change col2 col2 int;
select col2 from coo order by 1;
--numeric -> int, old prec >= 10, scal=0, numeric > min(int)
alter table coo change col3 col3 int;
select col3 from coo order by 1;

--numeric -> int, old prec >= 10, scal=0, numeric > max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 int;
select col4 from coo order by 1;

--numeric -> int, old prec >= 10, scal=0, numeric < min(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 int;
select col5 from coo order by 1;

--numeric -> int, scal > 0, min(int) < numeric < max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 int;
select col6 from coo order by 1;

--numeric -> int, scal > 0, numeric > max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 int;
select col7 from coo order by 1;

--numeric -> int, scal > 0, numeric < min(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col8 col8 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col8 col8 int;
select col8 from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
