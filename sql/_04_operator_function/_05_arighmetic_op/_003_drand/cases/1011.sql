--test drand function with numeric type
--select drand(10.11) from db_root order by 1;
select substr(to_char(drand(10.11)), 0, 11) from db_root order by 1;
