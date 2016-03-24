autocommit off;
    create class doo(a1 int);
    create class doo1(b1 doo);
    create class doo2(c1 doo1);
    create vclass vdoo(v1 doo1, v2 int) as select c1, na from doo2;
    alter vclass vdoo add query select na, a1 from doo;
    insert into doo(a1) values(5);
    select v1.b1.a1 from vdoo;
rollback;
