--+ holdcas on;
set system parameters 'no_backslash_escapes=no';
set @j='{"x": "\\""}';
SELECT @j, json_search( @j, 'one', '"') , json_extract(@j,'$.x');
SELECT @j, json_search( @j, 'one', '\"') , json_extract(@j,'$.x');
SELECT @j, json_search( @j, 'one', '\\"') , json_extract(@j,'$.x');

drop table if exists t;
create table t ( j json);
insert into t(j) values (@j);
select j, json_search( j, 'one', '"') , json_extract(j,'$.x') from t;
select j, json_search( j, 'one', '\"') , json_extract(j,'$.x') from t;
select j, json_search( j, 'one', '\\"') , json_extract(j,'$.x') from t;
set @p='\\"';
select j, json_search( j, 'one', @p)  from t;
set @p='\"';
select j, json_search( j, 'one', @p)  from t;
set @p='"';
select j, json_search( j, 'one', @p)  from t;
drop table if exists t;
set system parameters 'no_backslash_escapes=yes';
drop variable @j,@p;

--+ holdcas off;
