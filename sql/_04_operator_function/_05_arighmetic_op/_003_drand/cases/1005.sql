--[er]test drandom with time type and operators /,*
select drandom()/time'8:8:8 am' from db_root;
select drandom()*time'8:8:8 am' from db_root;

