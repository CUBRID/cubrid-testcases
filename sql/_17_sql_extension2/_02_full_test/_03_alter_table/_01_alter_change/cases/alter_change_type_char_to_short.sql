--+ holdcas on;
--alter_table_change_type_strict
--change the type of a char() column to short

create class coo(
        col1 char(10),
        col2 char(10),
        col3 char(10),
        col4 char(10),
	col5 char(10),
	col6 char(100)
);

insert into coo
 values('123', '12324234', '-847533', '12.3456', 'abc', 'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--char() -> short, number format -> number, no loss of data
alter table coo change col1 col1 short;
select col1 from coo order by 1;

--char() -> short, number format -> number, char() > max(short)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 short;
select col2 from coo order by 1;

--char() -> short, number format -> number, char() < min(short)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 short;
select col3 from coo order by 1;

--char() -> short, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 short;
select col4 from coo order by 1;


--char() -> short, string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 short;
select col5 from coo order by 1;


--char() -> short, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 short;
select col6 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
