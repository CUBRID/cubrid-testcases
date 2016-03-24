--+ holdcas on;
--alter_table_change_type_strict
--change the type of a nchar() column to short

create class coo(
        col1 nchar(10),
        col2 nchar(10),
        col3 nchar(10),
        col4 nchar(10),
	col5 nchar(10),
	col6 nchar(100)
);

insert into coo
 values(n'123', n'12324234', n'-847533', n'12.3456', n'abc', n'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--nchar() -> short, number format -> number, no loss of data
alter table coo change col1 col1 short;
select col1 from coo order by 1;

--nchar() -> short, number format -> number, nchar() > max(short)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 short;
select col2 from coo order by 1;

--nchar() -> short, number format -> number, nchar() < min(short)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 short;
select col3 from coo order by 1;

--nchar() -> short, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 short;
select col4 from coo order by 1;


--nchar() -> short, string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 short;
select col5 from coo order by 1;


--nchar() -> short, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 short;
select col6 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
