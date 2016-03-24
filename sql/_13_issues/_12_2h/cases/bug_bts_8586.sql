select * from db_collation order by coll_id;

select distinct charset_name from db_collation order by charset_name;
select distinct is_builtin from db_collation order by is_builtin;
select distinct has_expansions from db_collation order by has_expansions;

select * from db_collation where has_expansions='No' order by coll_id ;
select * from db_collation where has_expansions='Yes' order by coll_id ;

select * from db_collation where is_builtin='No' order by coll_id;
select * from db_collation where is_builtin='Yes' order by coll_id;

select * from db_collation where contractions=0 order by coll_id;
select * from db_collation where contractions > 0 order by coll_id;

select coll_id, coll_name, LENGTH(coll_name) from db_collation order by coll_id;
select coll_id, charset_name, LENGTH(charset_name) from db_collation order by coll_id;

select coll_id, is_builtin, LENGTH(is_builtin), has_expansions, LENGTH(has_expansions)
 from db_collation order by coll_id;

select SUM(contractions) from db_collation;

select charset_name, COUNT(charset_name) from db_collation group by charset_name order by charset_name;

select coll_id, CONCAT(coll_name, '-', charset_name) from db_collation order by coll_id;
