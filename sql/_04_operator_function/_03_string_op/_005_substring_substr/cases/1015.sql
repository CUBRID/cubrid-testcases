--test substring with incorrect position of from and for
select substring(b'0000111' for 2 from 2  ) from db_root order by 1;