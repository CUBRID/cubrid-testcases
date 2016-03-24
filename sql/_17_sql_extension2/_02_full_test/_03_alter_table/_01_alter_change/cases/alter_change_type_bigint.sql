--+ holdcas on;
--alter_table_change_type_strict
--change the type of a bigint column to other types

create class coo(
        col1 bigint,
        col2 bigint,
        col3 bigint,
        col4 bigint,
        col5 bigint,
        col6 bigint,
        col7 bigint,
        col8 bigint,
        col9 bigint,
        col10 bigint,
        col11 bigint,
        col12 bigint,
        col13 bigint,
        col14 bigint,
        col15 bigint,
	col16 bigint,
	col17 bigint,
	col18 bigint,
	col19 bigint,
	col20 bigint,
	col21 bigint,
	col22 bigint,
	col23 bigint,
	col24 bigint,
	col25 bigint
);

insert into coo
 values(7382729371234567890, 73829283412367890, -2342037561234567890, 8274386542145167890, -660321233123467890, 8372827341345167890, 8273848271234567890, 51826312312367890, -7153342551234567890, 8157832331345167890, -416273312123467890, 8153645341345167890, -934132543889967890, -2212726548067890, 3817947441188912345, -8745, 6271836242346333, -6283548, 512736433749320752, 7382729, -74832903323557, 8271926423625, -728194612899664463, 283456, 72938472899933542);


show columns in coo;


--bigint -> numeric, precision - scale >= 19
alter table coo change col1 col1 numeric(24, 4);
select col1 from coo order by 1;
--bigint -> numeric, precision - scale < 19, enough room for conversion
alter table coo change col2 col2 numeric(24, 6);
select col2 from coo order by 1;
--bigint -> numeric, precision - scale < 19, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 numeric(24, 7);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 numeric(24, 7);
select col3 from coo order by 1;


--bigint -> char, precision > 19+1
alter table coo change col4 col4 char(24);
select col4 from coo order by 1;
--bigint -> char, precision <= 19+1, enough room for conversion
alter table coo change col5 col5 char(20);
select col5 from coo order by 1;
--bigint -> char, precision <= 19+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 char(15);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 char(15);
select length(col6) from coo order by 1;



--bigint -> varchar, precision > 19+1 or new prec=-1
alter table coo change col7 col7 varchar;
select col7 from coo order by 1;
--bigint -> varchar, precision <= 19+1, enough room for conversion
alter table coo change col8 col8 varchar(20);
select col8 from coo order by 1;
--bigint -> varchar, precision <= 19+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col9 col9 varchar(17);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col9 col9 varchar(17);
select col9 from coo order by 1;



--bigint -> nchar, precision > 19+1
alter table coo change col10 col10 nchar(25);
select col10 from coo order by 1;
--bigint -> nchar, precision <= 19+1, enough room for conversion
alter table coo change col11 col11 nchar(20);
select col11 from coo order by 1;
--bigint -> nchar, precision <= 19+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col12 col12 nchar(15);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col12 col12 nchar(15);
select length(col12) from coo order by 1;



--bigint -> nchar varying, precision > 19+1, or new prec=-1
alter table coo change col13 col13 nchar varying(24);
select col13 from coo order by 1;
--bigint -> nchar varying, precision <= 19+1, enough room for conversion
alter table coo change col14 col14 nchar varying(20);
select col14 from coo order by 1;
--bigint -> nchar varying, precision <= 19+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col15 col15 nchar varying(16);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col15 col15 nchar varying(16);
select length(col15) from coo order by 1;



--bigint -> short, enough room for conversion
alter table coo change col16 col16 short;
select col16 from coo order by 1;
--bigint -> short, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col17 col17 short;
select col17 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col17 col17 short;
select col17 from coo order by 1;


--bigint -> float, enough room for conversion
alter table coo change col18 col18 float;
select col18 from coo order by 1;
--bigint -> float, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col19 col19 float;
select col19 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col19 col19 float;
select col19 from coo order by 1;


--bigint -> int, enough room for conversion
alter table coo change col20 col20 int;
select col20 from coo order by 1;
--bigint -> int, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col21 col21 int;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col21 col21 int;
select col21 from coo order by 1;


--bigint -> double, enough room for conversion
alter table coo change col22 col22 double;
select col22 from coo order by 1;
--bigint -> double, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col23 col23 double;
select col23 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col23 col23 double;
select col23 from coo order by 1;


--bigint -> monetary, enough room for conversion
alter table coo change col24 col24 monetary;
select col24 from coo order by 1;
--bigint -> monetary, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col25 col25 monetary;
select col25 from coo order by 1;
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col25 col25 monetary;
select col25 from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
