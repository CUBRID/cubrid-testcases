autocommit off;
create class c1 (a integer);
create class c2 (b c1);
create class c3 (c c2);
insert into c3 (c)
values (insert into c2 (b)
        values (insert into c1 (a)
                values (111)
               )
       );
create vclass vc (c c2)
as select c from c3;
select c.b.a from vc;
rollback work;
create class a1 (a int);
create class b1 (b a1);
create class c1 (c b1);
select c.b.a from c1;
rollback;
