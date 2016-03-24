--+ holdcas on;
--alter_table_change_type_strict
--change the type of a nchar varying() column to bigint

create class coo(
        col1 nchar varying(30),
        col2 nchar varying(30),
        col3 nchar varying(30),
        col4 nchar varying(30),
	col5 nchar varying(30),
	col6 nchar varying
);

insert into coo
 values(n'8237923123', n'123242347439281078412122', n'-748293021134255847533', n'187349232.3456', n'abc', n'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--nchar varying() -> bigint, number format -> number, no loss of data
alter table coo change col1 col1 bigint;
select col1 from coo order by 1;

--nchar varying() -> bigint, number format -> number, nchar varying() > max(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 bigint;
select col2 from coo order by 1;

--nchar varying() -> bigint, number format -> number, nchar varying() < min(bigint)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 bigint;
select col3 from coo order by 1;

--nchar varying() -> bigint, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 bigint;
select col4 from coo order by 1;


--nchar varying() -> bigint, string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 bigint;
select col5 from coo order by 1;


--nchar varying() -> bigint, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 bigint;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 bigint;
select col6 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
