--test substring with bit and keywords from, for
select substring(b'0000111' from 2 for 2 ) from db_root order by 1;