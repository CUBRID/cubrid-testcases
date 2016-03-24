--[er]test position with char and time
select position(to_time('8:8:8 am') in '5/5/2005 8:8:8 am') from db_root order by 1;