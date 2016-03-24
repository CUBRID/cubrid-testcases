-- [er]select clause with incr function and have an error 'expecting { qualified name } in path expression'

select incr(1) from db_root order by 1;