autocommit off;
create class target (a int, b string);
create class source (a int, b string);
create trigger source_insert 
after insert on source 
execute insert into target(a, b) values(obj.a, to_char(obj.a)); 
insert into source(a, b) values(1, 'test');
select * from target;
rollback;
