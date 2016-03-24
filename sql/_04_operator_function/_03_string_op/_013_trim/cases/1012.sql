--[er]test trim,ltrim,rtrim with time type
select trim(to_time('6:6:6 am')) from db_root;
select ltrim(to_time('6:6:6 am')) from db_root;
select rtrim(to_time('6:6:6 am')) from db_root;
