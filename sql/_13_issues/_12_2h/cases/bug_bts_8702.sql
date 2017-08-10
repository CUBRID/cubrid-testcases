--TEST: [Apricot BB] Wrong execution when have matched and not matched clause on client side merge


drop table if exists src, target;

--client side
create table src ( a INT);
insert into src values (1);

create table target ( c int, d int);
insert into target values (2, 100);
insert into target values (100, 2);
insert into target values (100, 4);

CREATE TABLE other (a int);
create trigger tr before insert on target EXECUTE INSERT INTO other VALUE(1);

--[er] 
merge into target t using src s on t.c = s.a 
when matched then update set t.c = 6
when not matched then insert (c, d)  VALUES(a, 200);

--success
merge into target t using src s on t.d = s.a
when matched then update set t.c = 6
when not matched then insert (c, d)  VALUES(a, 200);


select * from target order by 1, 2;
select if(count(*)=1, 'ok', 'nok') from other;

drop table other;
drop table src, target;


--server side
create table src ( a INT);
insert into src values (2);

create table target ( c int, d int);
insert into target values (2, 100);
insert into target values (100, 2);
insert into target values (100, 4);

--[er] 
merge into target t using src s on t.c = s.a
when matched then update set t.c = 6
when not matched then insert (c, d)  VALUES(a, 200);

--success
merge into target t using src s on t.d = s.a
when matched then update set t.c = 6
when not matched then insert (c, d)  VALUES(s.a, 200);

select * from target order by 1;

drop table src, target;
