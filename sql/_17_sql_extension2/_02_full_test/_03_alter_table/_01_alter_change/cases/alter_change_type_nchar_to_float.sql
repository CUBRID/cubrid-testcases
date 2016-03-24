--+ holdcas on;
--alter_table_change_type_strict
--change the type of a nchar() column to float

create class coo(
        col1 nchar(50),
        col2 nchar(50),
        col3 nchar(50),
        col4 nchar(50),
	col5 nchar(50),
	col6 nchar(50),
	col7 nchar(50),
	col8 nchar(100)
);

insert into coo
 values(n'-8237.923123', n'3.402823466E+38', n'3.402823466E+40', n'-3.402823466E+38', n'--3.402823466E+39', n'23423423.90728102893401982374883740192', n'abc', n'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--nchar() -> float, number format -> number, no loss of data
alter table coo change col1 col1 float;
select col1 from coo order by 1;

--nchar() -> float, number format -> number, nchar() = max(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 float;
select col2 from coo order by 1;

--nchar() -> float, number format -> number, nchar() > max(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 float;
select col3 from coo order by 1;

--nchar() -> float, number format -> number, nchar() = min(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 float;
select col4 from coo order by 1;

--nchar() -> float, number format -> number, nchar() < min(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 float;
select col5 from coo order by 1;

--nchar() -> float, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 float;
select col6 from coo order by 1;


--nchar() -> float, string -> number, no loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 float;
select col7 from coo order by 1;


--nchar() -> float, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col8 col8 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col8 col8 float;
select col8 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
