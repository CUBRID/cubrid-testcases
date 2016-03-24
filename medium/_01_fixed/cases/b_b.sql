autocommit off;
create class bB (b int);
insert into bB(b) values(4);
select b, b.b from Bb;
update bB set b = 5;
select b, b.b from Bb;
rollback;
