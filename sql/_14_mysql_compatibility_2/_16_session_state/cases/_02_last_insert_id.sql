create table t (i integer auto_increment primary key, s string);

insert into t (s) values('1');

select if (last_insert_id () = 1, 'ok', 'nok');

insert into t (s) values ('2'),('3'),('4'),('5');

select if (last_insert_id () = 5, 'ok', 'nok');

insert into t (i, s) values (6, 6);

select if (last_insert_id () = 5, 'ok', 'nok');

drop table t;

create serial lid start with 1000 increment by 2 maxvalue 20000;

create table t (i int primary key, s string);

insert into t (i, s) values (lid.NEXT_VALUE, '1000');

select if (last_insert_id () = 1000, 'ok', 'nok');

insert into t (i, s) values (lid.NEXT_VALUE, '1002');

select if (last_insert_id () = 1002, 'ok', 'nok');

drop table t;

drop serial lid;

create table t (i bigint auto_increment primary key, s string);

insert into t (s) values (1),(2);

select if (last_insert_id () = 2, 'ok', 'nok');

drop table t;