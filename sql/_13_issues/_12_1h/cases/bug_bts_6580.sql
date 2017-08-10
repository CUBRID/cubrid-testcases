--TEST: [Pseudocolumn in DEFAULT clause] UNIX_TIMESTAMP() in default clause of CREATE TABLE doesn't work.


create table t(
	id int primary key auto_increment,
	a timestamp default UNIX_TIMESTAMP(),
	b timestamp default CURRENT_TIMESTAMP,
	c timestamp default SYSTIMESTAMP
);


show columns in t;

insert into t default;
insert into t default;
insert into t default;
select if ((SYSTIMESTAMP-a) < 10, 'ok', 'nok')  from t order by id;
select if ((a-b) < 10, 'ok', 'nok')  from t order by id;
select if ((b-c) < 10, 'ok', 'nok') from t order by id;


insert into t(id) values(default), (default), (null);
select if ((SYSTIMESTAMP-a) < 10, 'ok', 'nok')  from t where id > 3 order by id;
select if ((a-b) < 10, 'ok', 'nok')  from t where id > 3 order by id;
select if ((b-c) < 10, 'ok', 'nok') from t where id > 3 order by id;


insert into t values(null, default, default, default);
insert into t values(null, default, default, default);
insert into t values(null, default, default, default);
select if ((SYSTIMESTAMP-a) < 10, 'ok', 'nok')  from t where id > 6 order by id;
select if ((a-b) < 10, 'ok', 'nok')  from t where id > 6 order by id;
select if ((b-c) < 10, 'ok', 'nok') from t where id > 6 order by id;


drop table t;
