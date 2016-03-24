--[er]test trim,ltrim,rtrim with date type
select trim(to_date('3/3/2003')) from db_root;
select ltrim(to_date('3/3/2003')) from db_root;
select rtrim(to_date('3/3/2003')) from db_root order by 1;