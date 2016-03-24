--[er]test operators superset with list(nchar) and list(nchar varying)
create class tb1 ( a list(nchar(2)));
create class tb2 ( b list(nchar VARYING(2)));

insert into tb1 values({n'a1'});
insert into tb1 values({n'a2'});
insert into tb1 values({n'a3'});

insert into tb2 values({n'a1'});
insert into tb2 values({n'a2'});
insert into tb2 values({n'a3'});
insert into tb2 values({n'a4'});
insert into tb2 values({n'a5'});

select a,b from tb1, tb2 where a superset b order by 1,2;

drop class tb1;
drop class tb2;
