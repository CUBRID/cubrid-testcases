--+ holdcas on;
--alter_table_change_type_strict
--change the type of a char() column to monetary

create class coo(
        col1 char(50),
        col2 char(50),
        col3 char(50),
        col4 char(50),
	col5 char(50),
	col6 char(50),
	col7 char(50),
	col8 char(100)
);

insert into coo
 values('-823342341234127.923123', '1.7976931348623157E+308', '1.7976931348623157E+310', '-1.7976931348623157E+308', '-1.7976931348623157E+309', '234234523452345223.90728102893401982374883740192', 'abc', 'lsakdjfjjdkjsldfjkdkdksllaieywieuriwue78236423746iuyuisjkfhskdjfhwkehkwehfkwefhw');


show columns in coo;
select * from coo order by 1;


--char() -> monetary, number format -> number, no loss of data
alter table coo change col1 col1 monetary;
select col1 from coo order by 1;

--char() -> monetary, number format -> number, char() = max(monetary)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 monetary;
select col2 from coo order by 1;

--char() -> monetary, number format -> number, char() > max(monetary)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 monetary;
select col3 from coo order by 1;

--char() -> monetary, number format -> number, char() = min(monetary)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 monetary;
select col4 from coo order by 1;

--char() -> monetary, number format -> number, char() < min(monetary)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 monetary;
select col5 from coo order by 1;

--char() -> monetary, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 monetary;
select col6 from coo order by 1;


--char() -> monetary, string -> number, no loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 monetary;
select col7 from coo order by 1;


--char() -> monetary, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col8 col8 monetary;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col8 col8 monetary;
select col8 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
