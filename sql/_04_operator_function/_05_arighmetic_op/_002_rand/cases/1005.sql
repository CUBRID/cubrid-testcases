--[er]test random with time type and operators /,*
select random()/time'8:8:8 am' from db_root;
select random()*time'8:8:8 am' from db_root;

