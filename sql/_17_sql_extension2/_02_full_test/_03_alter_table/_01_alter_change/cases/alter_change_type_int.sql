--+ holdcas on;
--alter_table_change_type_strict
--change the type of a int column to other types

create class coo(
        col1 int,
        col2 int,
        col3 int,
        col4 int,
        col5 int,
        col6 int,
        col7 int,
        col8 int,
        col9 int,
        col10 int,
        col11 int,
        col12 int,
        col13 int,
        col14 int,
        col15 int,
	col16 int,
	col17 int,
	col18 int,
	col19 int	
);

insert into coo
 values(1234567890, 12367890, -1234567890, 2145167890, -123467890, 1345167890, 1234567890, 12367890, -1234567890, 1345167890, -123467890, 1345167890, -889967890, -8067890, 1188912345, -5467, 2346333, -71928, 749320752);


show columns in coo;


--int -> numeric, precision - scale >= 10
alter table coo change col1 col1 numeric(15, 4);
select col1 from coo order by 1;
--int -> numeric, precision - scale < 10, enough room for conversion
alter table coo change col2 col2 numeric(15, 6);
select col2 from coo order by 1;
--int -> numeric, precision - scale < 10, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 numeric(15, 7);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 numeric(15, 7);
select col3 from coo order by 1;


--int -> char, precision > 10+1
alter table coo change col4 col4 char(15);
select col4 from coo order by 1;
--int -> char, precision <= 10+1, enough room for conversion
alter table coo change col5 col5 char(11);
select col5 from coo order by 1;
--int -> char, precision <= 10+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 char(9);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 char(9);
select length(col6) from coo order by 1;



--int -> varchar, precision > 10+1 or new prec=-1
alter table coo change col7 col7 varchar;
select col7 from coo order by 1;
--int -> varchar, precision <= 10+1, enough room for conversion
alter table coo change col8 col8 varchar(11);
select col8 from coo order by 1;
--int -> varchar, precision <= 10+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col9 col9 varchar(9);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col9 col9 varchar(9);
select col9 from coo order by 1;



--int -> nchar, precision > 10+1
alter table coo change col10 col10 nchar(15);
select col10 from coo order by 1;
--int -> nchar, precision <= 10+1, enough room for conversion
alter table coo change col11 col11 nchar(11);
select col11 from coo order by 1;
--int -> nchar, precision <= 10+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col12 col12 nchar(9);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col12 col12 nchar(9);
select length(col12) from coo order by 1;



--int -> nchar varying, precision > 10+1, or new prec=-1
alter table coo change col13 col13 nchar varying(15);
select col13 from coo order by 1;
--int -> nchar varying, precision <= 10+1, enough room for conversion
alter table coo change col14 col14 nchar varying(11);
select col14 from coo order by 1;
--int -> nchar varying, precision <= 10+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col15 col15 nchar varying(9);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col15 col15 nchar varying(9);
select length(col15) from coo order by 1;



--int -> short, enough room for conversion
alter table coo change col16 col16 short;
select col16 from coo order by 1;
--int -> short, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col17 col17 short;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col17 col17 short;
select col17 from coo order by 1;


--int -> float, enough room for conversion
alter table coo change col18 col18 float;
select col18 from coo order by 1;
--int -> float, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col19 col19 float;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col19 col19 float;
select col19 from coo order by 1;




show columns in coo;

drop table coo;


commit;
--+ holdcas off;
