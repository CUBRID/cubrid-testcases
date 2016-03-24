--[er]test drandom with timestamp type and operators /,*
select drandom()/timestamp'8/8/2008 8:8:8 am' from db_root;
select drandom()*timestamp'8/8/2008 8:8:8 am' from db_root;
