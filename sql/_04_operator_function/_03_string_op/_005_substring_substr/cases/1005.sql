--test substring with invalid format(without form keyword)
select substring('a', 'abc') from db_root order by 1;