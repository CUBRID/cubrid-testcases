--[er]test drandom with date type and operators /,*,+,-
select drandom()/date'8/8/2008' from db_root;
select drandom()*date'8/8/2008' from db_root;
