--+ holdcas on;
--alter_table_change_type_strict
--change the type of a char() column to double

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


--char() -> double, number format -> number, no loss of data
alter table coo change col1 col1 double;
select col1 from coo order by 1;

--char() -> double, number format -> number, char() = max(double)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 double;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 double;
select col2 from coo order by 1;

--char() -> double, number format -> number, char() > max(double)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 double;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 double;
select col3 from coo order by 1;

--char() -> double, number format -> number, char() = min(double)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col4 col4 double;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col4 col4 double;
select col4 from coo order by 1;

--char() -> double, number format -> number, char() < min(double)
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 double;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 double;
select col5 from coo order by 1;

--char() -> double, number format -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 double;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 double;
select col6 from coo order by 1;


--char() -> double, string -> number, no loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 double;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 double;
select col7 from coo order by 1;


--char() -> double, long string -> number, loss of data
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col8 col8 double;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col8 col8 double;
select col8 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
