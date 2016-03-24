--test drand function with bit type
select drand(b'00101010') from db_root order by 1;