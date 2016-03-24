--+ holdcas on;
--alter_table_change_type_strict
--change the type of a char() column to int

create class coo(
        col1 char(10),
        col2 char(20),
        col3 char(20),
        col4 char(20),
	col5 char(20),
	col6 char(100)
);

insert into coo
 values('-1234', '849492375612324234', '-847533628402', '1556542.3456', 'abc', 'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--char() -> int, number format -> number, no loss of data
alter table coo change col1 col1 int;
select col1 from coo order by 1;

--char() -> int, number format -> number, char() > max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 int;
select col2 from coo order by 1;

--char() -> int, number format -> number, char() < min(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 int;
select col3 from coo order by 1;

--char() -> int, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 int;
select col4 from coo order by 1;


--char() -> int, string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 int;
select col5 from coo order by 1;


--char() -> int, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 int;
select col6 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
