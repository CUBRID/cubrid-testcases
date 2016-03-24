--+ holdcas on;
--alter_table_change_type_strict
--change the type of a float column to other types

create class coo(
        col1 float,
        col2 float,
        col3 float,
        col4 float,
        col5 float,
        col6 float,
        col7 float,
        col8 float,
        col9 float,
        col10 float,
        col11 float,
        col12 float,
        col13 float,
        col14 float,
        col15 float,
	col16 float,
	col17 float,
	col18 float,
	col19 float,
	col20 float,
	col21 float
);

insert into coo
 values(7382, 2367890, -2342.037, 5167890, -6603.212, 7341345167890, 827384827123456.7890, 123.4567, -23.7382834234234, 23423.33, -1234.894, 234.5677, -11.456, 111.4567, 222.5433, -11794.77, 123.988, -11.5343, 666453.1, 48392727483.23, -4738295402890776322144.2390482309);


show columns in coo;
select * from coo order by 1;

--float -> short, no data loss
alter table coo change col1 col1 short;
select col1 from coo order by 1;
--float -> short, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col2 col2 short;
alter table coo change col3 col3 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col2 col2 short;
select col2 from coo order by 1;
alter table coo change col3 col3 short;
select col3 from coo order by 1;


--float -> int, no data loss
alter table coo change col4 col4 int;
select col4 from coo order by 1;
--float -> int, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col5 col5 int;
select col5 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col5 col5 int;
select col5 from coo order by 1;
--float -> int, out of int range
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col20 col20 int;
select col20 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col20 col20 int;
select col20 from coo order by 1;


--float -> bigint, no data loss
alter table coo change col6 col6 bigint;
select col6 from coo order by 1;
--float -> bigint, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col7 col7 bigint;
select col7 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col7 col7 bigint;
select col7 from coo order by 1;
--float -> bigint, out of bigint range
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col21 col21 bigint;
select col7 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col21 col21 bigint;
select col21 from coo order by 1;


--float -> numeric, no data loss
alter table coo change col8 col8 numeric(7, 4);
select col8 from coo order by 1;
--float -> numeric, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col9 col9 numeric(6, 4);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col9 col9 numeric(6, 4);
select col9 from coo order by 1;


--float -> char, no data loss
alter table coo change col10 col10 char(10); 
select col10 from coo order by 1;
--float -> char, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col11 col11 char(5); 
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col11 col11 char(5); 
select length(col11) from coo order by 1;


--float -> varchar, new prec=-1
alter table coo change col12 col12 varchar;
select col12 from coo order by 1;
--float -> varchar, no data loss
alter table coo change col13 col13 varchar(100); 
select col13 from coo order by 1;
--float -> varchar, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col14 col14 varchar(3); 
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col14 col14 varchar(3); 
select length(col14) from coo order by 1;


--float -> nchar, no data loss
alter table coo change col15 col15 nchar(10); 
select col15 from coo order by 1;
--float -> nchar, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col16 col16 nchar(4); 
select col16 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col16 col16 nchar(4); 
select length(col16) from coo order by 1;


--float -> nchar varying, new prec=-1
alter table coo change col17 col17 nchar varying;
select col17 from coo order by 1;
--float -> nchar varying, no data loss
alter table coo change col18 col18 nchar varying(20);
select col18 from coo order by 1;
--float -> nchar varying, data loss occurs
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col19 col19 nchar varying(2);
select col19 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col19 col19 nchar varying(2);
select length(col19) from coo order by 1;



show columns in coo;

drop table coo;


commit;
--+ holdcas off;
