autocommit off;
create class settyp (a set);
insert into settyp values({3});
select a + {'hi'} from settyp;
rollback;
