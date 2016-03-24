select bit_count(cast(9 as short)) from db_root;
select bit_count(cast(9 as int)) from db_root;
select bit_count(cast(9 as bigint)) from db_root;
select bit_count(cast(9.1 as float)) from db_root;
select bit_count(cast(9.1 as double)) from db_root;
select bit_count(cast(9 as numeric)) from db_root;
select bit_count(cast(9 as monetary)) from db_root;

select bit_count(cast(-9 as short)) from db_root;
select bit_count(cast(-9 as int)) from db_root;
select bit_count(cast(-9 as bigint)) from db_root;
select bit_count(cast(-9.1 as float)) from db_root;
select bit_count(cast(-9.1 as double)) from db_root;
select bit_count(cast(-9 as numeric)) from db_root;
select bit_count(cast(-9 as monetary)) from db_root;
