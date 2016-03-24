select charset,lang from db_root where (select 1 from db_root) not in (select 4 from db_root);

