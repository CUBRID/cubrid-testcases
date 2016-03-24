--[er]test position with char and date
select position(to_date('5/5/2005') in '5/5/2005 8:8:8 am') from db_root order by 1;