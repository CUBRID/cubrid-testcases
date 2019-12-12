--+ holdcas on;
--alter_table_change_type_strict
--change the type of a nchar varying() column to monetary

create class coo(
        col1 nchar varying(50),
        col2 nchar varying(50),
        col3 nchar varying(50),
        col4 nchar varying(50),
	col5 nchar varying(50),
	col6 nchar varying(50),
	col7 nchar varying(50),
	col8 nchar varying(100)
);

insert into coo
 values(n'-823342341234127.923123', n'1.7976931348623157E+308', n'1.7976931348623157E+310', n'-1.7976931348623157E+308', n'-1.7976931348623157E+309', n'234234523452345223.90728102893401982374883740192', n'abc', n'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--nchar varying() -> monetary, number format -> number, no loss of data
alter table coo change col1 col1 monetary;
select col1 from coo order by 1;

--nchar varying() -> monetary, number format -> number, nchar varying() = max(monetary)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 monetary;
select col2 from coo order by 1;

--nchar varying() -> monetary, number format -> number, nchar varying() > max(monetary)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 monetary;
select col3 from coo order by 1;

--nchar varying() -> monetary, number format -> number, nchar varying() = min(monetary)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 monetary;
select col4 from coo order by 1;

--nchar varying() -> monetary, number format -> number, nchar varying() < min(monetary)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 monetary;
select col5 from coo order by 1;

--nchar varying() -> monetary, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 monetary;
select col6 from coo order by 1;


--nchar varying() -> monetary, string -> number, no loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 monetary;
select col7 from coo order by 1;


--nchar varying() -> monetary, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col8 col8 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col8 col8 monetary;
select col8 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
