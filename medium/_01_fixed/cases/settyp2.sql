autocommit off;
create class settyp (a set);
insert into settyp values({3}) to p1;
evaluate {p1, 'hi'} to p2;
select p2 from class settyp;
rollback;
