--+ holdcas on;
--alter_table_change_type_strict
--change the type of a short column to other types

create class coo(
        col1 short,
        col2 short,
        col3 short,
        col4 short,
        col5 short,
        col6 short,
        col7 short,
        col8 short,
        col9 short,
        col10 short,
        col11 short,
        col12 short,
        col13 short,
        col14 short,
        col15 short
);

insert into coo 
 values(12345, 123, -12345, 23451, -1234, 23451, 12345, 123, -12345, 23451, -1234, 23451, -8899, -80, 11889);


show columns in coo;


--short -> numeric, precision - scale >= 5
alter table coo change col1 col1 numeric(10, 4);
select col1 from coo order by 1;
--short -> numeric, precision - scale < 5, enough room for conversion
alter table coo change col2 col2 numeric(10, 6);
select col2 from coo order by 1;
--short -> numeric, precision - scale < 5, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col3 col3 numeric(10, 7);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col3 col3 numeric(10, 7);
select col3 from coo order by 1;


--short -> char, precision > 5+1
alter table coo change col4 col4 char(10);
select col4 from coo order by 1;
--short -> char, precision <= 5+1, enough room for conversion
alter table coo change col5 col5 char(6);
select col5 from coo order by 1;
--short -> char, precision <= 5+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col6 col6 char(4);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col6 col6 char(4);
select length(col6) from coo order by 1;



--short -> varchar, precision > 5+1 or new prec=-1
alter table coo change col7 col7 varchar;
select col7 from coo order by 1;
--short -> varchar, precision <= 5+1, enough room for conversion
alter table coo change col8 col8 varchar(6);
select col8 from coo order by 1;
--short -> varchar, precision <= 5+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col9 col9 varchar(4);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col9 col9 varchar(4);
select length(col9) from coo order by 1;



--short -> nchar, precision > 5+1
alter table coo change col10 col10 nchar(10);
select col10 from coo order by 1;
--short -> nchar, precision <= 5+1, enough room for conversion
alter table coo change col11 col11 nchar(6);
select col11 from coo order by 1;
--short -> nchar, precision <= 5+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col12 col12 nchar(4);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col12 col12 nchar(4);
select length(col12) from coo order by 1;



--short -> nchar varying, precision > 5+1, or new prec=-1
alter table coo change col13 col13 nchar varying(10);
select col13 from coo order by 1;
--short -> nchar varying, precision <= 5+1, enough room for conversion
alter table coo change col14 col14 nchar varying(6);
select col14 from coo order by 1;
--short -> nchar varying, precision <= 5+1, lack of room for conversion
set system parameters 'alter_table_change_type_strict=yes';
alter table coo change col15 col15 nchar varying(4);
set system parameters 'alter_table_change_type_strict=no';
alter table coo change col15 col15 nchar varying(4);
select length(col15) from coo order by 1;


show columns in coo;

drop table coo;


commit;
--+ holdcas off;
