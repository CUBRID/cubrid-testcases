--[er]test position with char and timestamp
select position(to_timestamp('5/5/2005 8:8:8 am') in '5/5/2005 8:8:8 am') from db_root order by 1;