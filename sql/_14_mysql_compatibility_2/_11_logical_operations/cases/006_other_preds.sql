create table t (i int, j int, k int, l int);
insert into t values
(0,0,0,0),
(0,0,1,1),
(0,1,0,2),
(0,1,1,3),
(1,0,0,4),
(1,0,1,5),
(1,1,0,6),
(1,1,1,7),
(null, 0, 0, 8),
(null, 1, 1, 9),
(0, null, 0, 10),
(1, null, 1, 11),
(0, 0, null, 12),
(1, 1, null, 13),
(null, null, null, 14);


select i,count(*) from t group by i having not i;
select i, (count(*)=3) from t group by i having i and j;

select count(*) as join_none from t t1 join t t2 on 0;
select count(*) as join_full from t t1 join t t2 on 1;
select count(*) from t t1 join t t2 on t1.i;
select count(*) from t t1 join t t2 on t1.i and t2.j;


create table u(x int, y int);
insert into u values (1,99), (0,22);
select i,x from t inner join u on (not t.i)+1=(not (not u.x));
drop table u;


select l,prior l from t start with not l connect by (prior l+1 = l) order by l;



drop table t;