autocommit off;
select name from db_user where name in ('JOE');
select name from db_user where name in ('FRED', 'JOE');
select name from db_user where name in {'JOE'};
select name from db_user where name not in 
	(select name from db_user where name in ('FRED', 'JOE'));
rollback;
