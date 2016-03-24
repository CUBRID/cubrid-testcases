--test trim,ltrim,rtrim and one of these was embeded others in a select query. 
select trim(ltrim(rtrim('    abc    '))) from db_root;
select trim(ltrim(rtrim(n'    abc    '))) from db_root;
select trim(ltrim(rtrim(n''))) from db_root;
select trim(ltrim(rtrim(''))) from db_root;
select trim(ltrim(rtrim(null))) from db_root;
