--[er]test nvl, nvl2 with not null
select nvl(not null, 'ok') from db_root;
select nvl2(not null, 'ok1', 'ok2') from db_root;
