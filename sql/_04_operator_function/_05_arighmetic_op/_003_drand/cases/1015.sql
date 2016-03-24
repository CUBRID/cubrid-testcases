--test drand function with null
--select drand(null) from db_root order by 1;
select substr(to_char(drand(null)), 0, 11) from db_root order by 1;
