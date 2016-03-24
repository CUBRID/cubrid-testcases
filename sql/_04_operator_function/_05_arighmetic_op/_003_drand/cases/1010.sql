--test drand function with int type
--select drand(10) from db_root order by 1;
select substr(to_char(drand(10)), 0, 11) from db_root order by 1;
