--+ holdcas on;
--alter_table_change_type_strict
--change the type of a numeric column to bigint

create class coo(
        col1 numeric(13),
        col2 numeric(19),
        col3 numeric(19),
        col4 numeric(22),
        col5 numeric(23),
        col6 numeric(13, 3),
        col7 numeric(25, 4),
        col8 numeric(25, 4)
);

insert numerico coo
 values(7382234738923, 1234523456837297104, -2112354321738293654, 5167890739284328473254, -66034383829127482934271, 8463457655.123, 654321829354847311223.1234, -736283562934489013542.5342);


show columns in coo;


--numeric -> bigint, old prec < 19, scale=0
alter table coo change col1 col1 bigint;
select * from coo order by 1;

--numeric -> bigint, old prec >= 19, scal=0, numeric < max(bigint)
alter table coo change col2 col2 bigint;
--numeric -> bigint, old prec >= 19, scal=0, numeric > min(bigint)
alter table coo change col3 col3 bigint;
select * from coo order by 1;

--numeric -> bigint, old prec >= 19, scal=0, numeric > max(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 bigint;
select * from coo order by 1;

--numeric -> bigint, old prec >= 19, scal=0, numeric < min(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 bigint;
select * from coo order by 1;

--numeric -> bigint, scal > 0, min(bigint) < numeric < max(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 bigint;
select * from coo order by 1;

--numeric -> bigint, scal > 0, numeric > max(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 bigint;
select * from coo order by 1;

--numeric -> bigint, scal > 0, numeric < min(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col8 col8 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col8 col8 bigint;
select * from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
