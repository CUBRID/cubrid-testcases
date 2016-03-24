--+ holdcas on;
--alter_table_change_type_strict
--change the type of a varchar() column to float

create class coo(
        col1 varchar(50),
        col2 varchar(50),
        col3 varchar(50),
        col4 varchar(50),
	col5 varchar(50),
	col6 varchar(50),
	col7 varchar(50),
	col8 varchar
);

insert into coo
 values('-8237.923123', '3.402823466E+38', '3.402823466E+40', '-3.402823466E+38', '-3.402823466E+39', '23423423.90728102893401982374883740192', 'abc', 'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--varchar() -> float, number format -> number, no loss of data
alter table coo change col1 col1 float;
select col1 from coo order by 1;

--varchar() -> float, number format -> number, varchar() = max(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 float;
select col2 from coo order by 1;

--varchar() -> float, number format -> number, varchar() > max(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 float;
select col3 from coo order by 1;

--varchar() -> float, number format -> number, varchar() = min(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 float;
select col4 from coo order by 1;

--varchar() -> float, number format -> number, varchar() < min(float)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 float;
select col5 from coo order by 1;

--varchar() -> float, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 float;
select col6 from coo order by 1;


--varchar() -> float, string -> number, no loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 float;
select col7 from coo order by 1;


--varchar() -> float, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col8 col8 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col8 col8 float;
select col8 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
