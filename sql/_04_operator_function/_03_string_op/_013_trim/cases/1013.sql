--[er]test trim,ltrim,rtrim with timestamp type
select trim(to_timestamp('5/5/2005 6:6:6 am')) from db_root;
select ltrim(to_timestamp('5/5/2005 6:6:6 am')) from db_root;
select rtrim(to_timestamp('5/5/2005 6:6:6 am')) from db_root order by 1;