--insert/update/delete trigger on enum column.


create table ins(
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink'),
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat') not null,
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry')
);

create table tact(
	id int primary key auto_increment,
	status enum('insert', 'statement insert', 'update', 'statement update', 'delete', 'statement delete')
);

--create triggers
create trigger i before insert on ins
execute insert into tact(status) values('insert');
create trigger si after statement insert on ins
execute insert into tact(status) values(2);
create trigger u before update on ins
execute insert into tact(status) values(3);
create trigger su after statement update on ins
execute insert into tact(status) values('statement update');
create trigger d after delete on ins
execute insert into tact(status) values('delete');
create trigger sd before statement delete on ins
execute insert into tact(status) values(6);


--TEST: insert 1 row
insert into ins values('blue', 3, 'banana');
insert into ins values(1, 2, 3);
--TEST: check trigger result
select if (count(*)=2, 'ok', 'nok') from tact where status=1;
select if (count(*)=2, 'ok', 'nok') from tact where status=2;

--TEST: insert multiple rows
insert into ins select * from ins;
--TEST: check trigger result
select if (count(*)=4, 'ok', 'nok') from tact where status='insert';
select if (count(*)=3, 'ok', 'nok') from tact where status='statement insert';

--TEST: update 1 row
update ins set _day=1, fruit='peach' where color < 3 limit 1;
--TEST: check trigger result
select if (count(*)=1, 'ok', 'nok') from tact where status='update';
select if (count(*)=1, 'ok', 'nok') from tact where status='statement update';

--TEST: update multiple rows
update ins set color='pink', fruit=fruit+1 order by fruit desc limit 3;
--TEST: check trigger result
select if (count(*)=4, 'ok', 'nok') from tact where status=3;
select if (count(*)=2, 'ok', 'nok') from tact where status=4;

--TEST: delete 1 row
delete from ins where fruit > 1 limit 1;
--TEST: check trigger result
select if (count(*)=1, 'ok', 'nok') from tact where status=5;
select if (count(*)=1, 'ok', 'nok') from tact where status=6;

--TEST: delete mltiple rows
delete from ins limit 10;
--TEST: check trigger result
select if (count(*)=4, 'ok', 'nok') from tact where status='delete';
select if (count(*)=2, 'ok', 'nok') from tact where status='statement delete';


drop trigger i, si, u, su, d, sd;
drop table ins, tact;


