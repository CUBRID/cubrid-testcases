autocommit off;
create table x (d date, u timestamp, t time);
insert into x values (DATE '1/1/1900', TIMESTAMP '1/1/2000', TIME '12:00');
insert into x values (DATE '1/1/1910', TIMESTAMP '1/1/2010', TIME '12:10');
select * from x where d in (DATE '1/1/1900', DATE '1/1/2000');
select * from x where u in (TIMESTAMP '1/1/1990', TIMESTAMP '1/1/2000');
select * from x where t in (TIME '11:00', TIME '12:00');
rollback;
