--TEST: [Pseudocolumn in DEFAULT clause] default value of SYSDATE/SYSTIMESTAMP in trigger action doesn't work.


create table foo(a int primary key auto_increment, b timestamp default SYSTIMESTAMP, c timestamp default UNIX_TIMESTAMP());


create table aoo(id short auto_increment, a timestamp default CURRENT_TIMESTAMP, b date default SYSDATE, c datetime default SYSDATETIME, d char(10) default USER);

create trigger trig1 after insert on foo execute insert into aoo default;
create trigger trig2 before update on foo execute insert into aoo(id) values(2);
create trigger trig3 after update on foo execute insert into aoo(id, b, d) values(3, '1999-1-1', 'abc');
create trigger trig4 before delete on foo execute update aoo set b=default, d=default;

--insert
insert into foo(a, c) values(default, '2000-1-1 1:1:1');
select if((SYSTIMESTAMP - b) < 2, 'ok', 'nok') from foo;
select if((SYSTIMESTAMP - a) < 2 and b=SYSDATE and (SYSDATETIME - c) < 1000 and d=CURRENT_USER, 'ok', 'nok') from aoo;

--update
update foo set c=default;
select if((SYSTIMESTAMP - c) < 2, 'ok', 'nok') from foo;
select if((SYSTIMESTAMP - a) < 2 and b=SYSDATE and (SYSDATETIME - c) < 1000 and d=CURRENT_USER, 'ok', 'nok') from aoo where id=2;
select if((SYSTIMESTAMP - a) < 2 and (SYSDATETIME - c) < 1000, 'ok', 'nok') from aoo where id=3;

--delete
delete from foo where a=1;
select if(count(*)=0, 'ok', 'nok') from foo;
select if(b=SYSDATE and d=CURRENT_USER, 'ok', 'nok') from aoo where id=3;


drop trigger trig1, trig2, trig3, trig4;
drop table foo, aoo;





