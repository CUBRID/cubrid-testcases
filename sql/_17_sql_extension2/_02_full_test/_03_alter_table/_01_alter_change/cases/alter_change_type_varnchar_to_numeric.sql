--+ holdcas on;
--alter_table_change_type_strict
--change the type of a numeric column to numeric

create table coo(
        col1 nchar varying(10),
        col2 nchar varying(10),
	col3 nchar varying(10),
	col4 nchar varying(10),
	col5 nchar varying(10),
	col6 nchar varying(10),
	col7 nchar varying(10),
	col8 nchar varying(10),
	col9 nchar varying(10),
	col10 nchar varying(10),
	col11 nchar varying(10),
	col12 nchar varying(10)
);

insert into coo
 values(n'123.345', n'234.345', n'345.456', n'456.567', n'567.678', n'678.789', n'123.345', n'234.345', n'345.456', n'456.567', n'567.678', n'678.789');


show columns in coo;


--numeric -> numeric, no changes in prec and scale
alter table coo change col1 col1 numeric(6, 3);
select col1 from coo order by 1;

--numeric -> numeric, both prec and scale increase with the same value
alter table coo change col2 col2 numeric(8, 5);
select col2 from coo order by 1;

--numeric -> numeric, prec and scale increase with different values
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 numeric(8, 4);
alter table coo change col4 col4 numeric(7, 5);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 numeric(8, 4);
alter table coo change col4 col4 numeric(7, 5);
select col3, col4 from coo order by 1;

--numeric -> numeric, both prec and scale decrease
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 numeric(5, 2);
alter table coo change col6 col6 numeric(4, 2);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 numeric(5, 2);
alter table coo change col6 col6 numeric(4, 2);
select col5, col6 from coo order by 1;

--numeric -> numeric, prec increases and no change in scale
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 numeric(7, 3);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 numeric(7, 3);
select col7 from coo order by 1;

--numeric -> numeric, prec decreases and no change in scale
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col8 col8 numeric(5, 3);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col8 col8 numeric(5, 3);
select col8 from coo order by 1;

--numeric -> numeric, no change in prec and scale increases
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col9 col9 numeric(6, 4);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col9 col9 numeric(6, 4);
select col9 from coo order by 1;

--numeric -> numeric, no change in prec and scale decreases
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col10 col10 numeric(6, 2);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col10 col10 numeric(6, 2);
select col10 from coo order by 1;

--numeric -> numeric, prec increases and scale decreases
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col11 col11 numeric(8, 2);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col11 col11 numeric(8, 2);
select col11 from coo order by 1;

--numeric -> numeric, prec decreases and scale increases
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col12 col12 numeric(5, 4);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col12 col12 numeric(5, 4);
select col12 from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
