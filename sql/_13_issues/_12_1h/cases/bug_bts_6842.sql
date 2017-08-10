--TEST: query execution failure in multi-table delete using left outer join

create table md_int1(id1 int);
insert into md_int1 values(1);
insert into md_int1 values(2);
insert into md_int1 values(3);
insert into md_int1 values(4);
insert into md_int1 values(5);
insert into md_int1 values(6);

create table md_int2(id2 int);
insert into md_int2 values(2);
insert into md_int2 values(3);
insert into md_int2 values(4);


select * from md_int1 m1 left outer join md_int2 m2 on m1.id1=m2.id2;

delete m1, m2 from md_int1 m1 left outer join md_int2 m2 on m1.id1=m2.id2;

select if (count(*)=0, 'ok', 'nok') from md_int1;
select if (count(*)=0, 'ok', 'nok') from md_int2;


drop table md_int1, md_int2;


