autocommit off;
create class b (b1 int);
create class a (a1 int, a2 set b);
create trigger btrig
before insert on b
execute update a set a2 = a2 + {new} where a1 = 1;
insert into a (a1, a2) values (1, {});
insert into b (b1) values (1);
select * from a;
rollback work;
create class b (b1 int);
create class a (a1 int, a2 set b);
create trigger btrig
after insert on b
execute update a set a2 = a2 + {obj} where a1 = 1;
insert into a (a1, a2) values (1, {});
insert into b (b1) values (1);
select * from a;
select a1, c.b1 from a, table(a2) as t(c);
rollback;
