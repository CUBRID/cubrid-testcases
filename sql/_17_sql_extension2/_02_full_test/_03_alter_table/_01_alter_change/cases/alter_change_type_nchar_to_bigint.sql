--+ holdcas on;
--alter_table_change_type_strict
--change the type of a nchar() column to bigint

create class coo(
        col1 nchar(30),
        col2 nchar(30),
        col3 nchar(30),
        col4 nchar(30),
	col5 nchar(30),
	col6 nchar(100)
);

insert into coo
 values(n'8237923123', n'123242347439281078412122', n'-748293021134255847533', n'187349232.3456', n'abc', n'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--nchar() -> bigint, number format -> number, no loss of data
alter table coo change col1 col1 bigint;
select col1 from coo order by 1;

--nchar() -> bigint, number format -> number, nchar() > max(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 bigint;
select col2 from coo order by 1;

--nchar() -> bigint, number format -> number, nchar() < min(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 bigint;
select col3 from coo order by 1;

--nchar() -> bigint, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 bigint;
select col4 from coo order by 1;


--nchar() -> bigint, string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 bigint;
select col5 from coo order by 1;


--nchar() -> bigint, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 bigint;
select col6 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
