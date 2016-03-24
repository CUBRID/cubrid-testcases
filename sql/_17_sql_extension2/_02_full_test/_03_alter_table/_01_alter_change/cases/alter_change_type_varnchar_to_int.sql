--+ holdcas on;
--alter_table_change_type_strict
--change the type of a nchar varying() column to int

create class coo(
        col1 nchar varying(10),
        col2 nchar varying(20),
        col3 nchar varying(20),
        col4 nchar varying(20),
	col5 nchar varying(20),
	col6 nchar varying
);

insert into coo
 values(n'-1234', n'849492375612324234', n'-847533628402', n'1556542.3456', n'abc', n'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--nchar varying() -> int, number format -> number, no loss of data
alter table coo change col1 col1 int;
select col1 from coo order by 1;

--nchar varying() -> int, number format -> number, nchar varying() > max(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 int;
select col2 from coo order by 1;

--nchar varying() -> int, number format -> number, nchar varying() < min(int)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 int;
select col3 from coo order by 1;

--nchar varying() -> int, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 int;
select col4 from coo order by 1;


--nchar varying() -> int, string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 int;
select col5 from coo order by 1;


--nchar varying() -> int, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 int;
select col6 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
