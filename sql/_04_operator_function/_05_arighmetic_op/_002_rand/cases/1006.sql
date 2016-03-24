--[er]test random with timestamp type and operators /,*
select random()/timestamp'8/8/2008 8:8:8 am' from db_root;
select random()*timestamp'8/8/2008 8:8:8 am' from db_root;
