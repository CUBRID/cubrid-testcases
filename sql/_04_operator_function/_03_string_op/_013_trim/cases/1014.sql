--test trim,ltrim,rtrim with nchar type
select trim(n'        nchar      ') from db_root;
select ltrim(n'     nchar   ') from db_root;
select rtrim(n('         nchar       ') from db_root order by 1;