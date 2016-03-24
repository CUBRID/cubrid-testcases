--+ holdcas on;
--alter_table_change_type_strict
--change the type of a double column to other types

create class coo(
        col1 double,
        col2 double,
        col3 double,
        col4 double,
        col5 double,
        col6 double,
        col7 double,
        col8 double,
        col9 double,
        col10 double,
        col11 double,
        col12 double,
        col13 double,
        col14 double,
        col15 double,
	col16 double,
	col17 double,
	col18 double,
	col19 double,
	col20 double,
	col21 double,
	col22 double, 
	col23 double
);

insert into coo
 values(7382, 2367890, -2342.0372342, 5167890, -6603.212238749234, 7341345167890, 827384827123456.7890, 123.4567, -23.7382834234234, 23423.33, -1234.894, 234.5677, -11.456, 111.4567, 222.5433, -11794.77, 123.988, -11.5343, 666453.1, 234.65, 123435738292988237420934.9782394872, -374888372922.34, 849302002253434482224.324234);


show columns in coo;
select * from coo order by 1;

--double -> short, no data loss
alter table coo change col1 col1 short;
select col1 from coo order by 1;
--double -> short, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 short;
alter table coo change col3 col3 short;
select col2, col3 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 short;
alter table coo change col3 col3 short;
select col2, col3 from coo order by 1;


--double -> int, no data loss
alter table coo change col4 col4 int;
select col4 from coo order by 1;
--double -> int, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 int;
alter table coo change col22 col22 int;
select col5, col22 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 int;
alter table coo change col22 col22 int;
select col5, col22 from coo order by 1;


--double -> bigint, no data loss
alter table coo change col6 col6 bigint;
select col6 from coo order by 1;
--double -> bigint, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 bigint;
alter table coo change col23 col23 bigint;
select col7, col23 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 bigint;
alter table coo change col23 col23 bigint;
select col7, col23 from coo order by 1;


--double -> numeric, no data loss
alter table coo change col8 col8 numeric(7, 4);
select col8 from coo order by 1;
--double -> numeric, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col9 col9 numeric(6, 4);
select col9 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col9 col9 numeric(6, 4);
select col9 from coo order by 1;


--double -> char, no data loss
alter table coo change col10 col10 char(10); 
select col10 from coo order by 1;
--double -> char, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col11 col11 char(5); 
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col11 col11 char(5); 
select col11 from coo order by 1;


--double -> varchar, new prec=-1
alter table coo change col12 col12 varchar;
select col12 from coo order by 1;
--double -> varchar, no data loss
alter table coo change col13 col13 varchar(100); 
select col13 from coo order by 1;
--double -> varchar, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col14 col14 varchar(3); 
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col14 col14 varchar(3); 
select length(col14) from coo order by 1;


--double -> nchar, no data loss
alter table coo change col15 col15 nchar(10); 
select col15 from coo order by 1;
--double -> nchar, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col16 col16 nchar(4); 
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col16 col16 nchar(4); 
select col16 from coo order by 1;


--double -> nchar varying, new prec=-1
alter table coo change col17 col17 nchar varying;
select col17 from coo order by 1;
--double -> nchar varying, no data loss
alter table coo change col18 col18 nchar varying(20);
select col18 from coo order by 1;
--double -> nchar varying, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col19 col19 nchar varying(2);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col19 col19 nchar varying(2);
select length(col19) from coo order by 1;


--double -> float, no data loss
alter table coo change col20 col20 float;
select col20 from coo order by 1;
--double -> float, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col21 col21 float;
select col21 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col21 col21 float;
select col21 from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
