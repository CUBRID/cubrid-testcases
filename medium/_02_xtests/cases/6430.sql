autocommit off;
create class bar(sintval smallint, dateval date);
insert into bar(sintval,dateval) values(3, date'01/07/1900');
select * from bar;
select sintval + dateval from bar;
rollback;
