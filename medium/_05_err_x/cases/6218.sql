autocommit off;

create class A1;
create class B1 ( B2 sequence of (A1));
alter class A1 add attribute A2 B1,
			     A3 int;
insert into A1 (A3) values (10) into A1ptr10;
insert into B1 (B2) values ( {A1ptr10}) into B1ptr10;
update object A1ptr10 set A2 = B1ptr10;
create class C1 ( C2 int);
insert into C1 (C2) values (11) into C1ptr11;
update object B1ptr10 set B2 = B2 + {C1ptr11};
rollback;
