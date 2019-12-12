create table t (a int, b monetary default unix_timestamp());
create table s (a int, b datetime default current_timestamp);

create table aux (a int);
insert into aux values (3);

insert into t values (1, default);
insert into t(a) values (2);
insert into t(a) select a from aux;

select 
	a, if (year (cast (unix_timestamp() as timestamp)) 
			  = year (cast (cast (b as int) as timestamp)),
			  'ok', 'nok') is_ok
	from t;	

insert into s values (1, default);
insert into s(a) values (2);
insert into s(a) select a from aux;

select a, if (year (b) = year (current_timestamp), 'ok', 'nok') is_ok from s;

drop t;
drop s;
drop aux;



-- check insert unix_timestamp()
create table t (a timestamp, b monetary);
insert into t values (unix_timestamp(), unix_timestamp());

select 
	if (year (a) = year (cast (unix_timestamp() as timestamp)), 'ok', 'nok') a_is_ok,
	if (year (cast (cast (b as int) as timestamp)) = year (cast (unix_timestamp() as timestamp)),
		'ok', 'nok') b_is_ok
	from t;
	
drop t;
