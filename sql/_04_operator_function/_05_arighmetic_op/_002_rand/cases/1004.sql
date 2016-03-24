--[er]test random with date type and operators /,*,+,-
select random()/date'8/8/2008' from db_root;
select random()*date'8/8/2008' from db_root;
