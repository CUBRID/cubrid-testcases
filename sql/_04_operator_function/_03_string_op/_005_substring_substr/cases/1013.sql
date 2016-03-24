--test substring with char and keywords from, for
select substring('1234567890' from 3 for -1) from db_root;
select substring('1234567890' from 3 for 1) from db_root;
select substring('1234567890' from 3 for 100) from db_root;
select substring('1234567890' from 3 for 0) from db_root;
select substring(null from null for null) from db_root order by 1;