autocommit off;
create table o1 ( i int, j int );
create table o2 ( i int, j int );
create serial s1 start with 0;
create serial s2 start with 0 increment by 2;
create serial s3 start with 0;
create serial s4 start with 0 increment by 4;
insert into o1 values (s1.next_value, s2.next_value);
insert into o1 values (s1.next_value, s2.next_value);
insert into o1 values (s1.next_value, s2.next_value);
insert into o1 values (s1.next_value, s2.next_value);
insert into o1 values (s1.next_value, s2.next_value);
insert into o1 values (s1.next_value, s2.next_value);
insert into o1 values (s1.next_value, s2.next_value);
insert into o1 values (s1.next_value, s2.next_value);
insert into o1 values (s1.next_value, s2.next_value);
insert into o1 values (s1.next_value, s2.next_value);
insert into o2 values (s3.next_value, s4.next_value);
insert into o2 values (s3.next_value, s4.next_value);
insert into o2 values (s3.next_value, s4.next_value);
insert into o2 values (s3.next_value, s4.next_value);
insert into o2 values (s3.next_value, s4.next_value);
insert into o2 values (s3.next_value, s4.next_value);
insert into o2 values (s3.next_value, s4.next_value);
insert into o2 values (s3.next_value, s4.next_value);
insert into o2 values (s3.next_value, s4.next_value);
insert into o2 values (s3.next_value, s4.next_value);
select *
from o1 left outer join o2 on o1.i = o2.i order by 1,2,3,4;
select *
from o1 left outer join o2 on o1.j = o2.j order by 1,2,3,4;
select *
from o1 left outer join o2 on o1.i = o2.i and o1.j = o2.j order by 1,2,3,4;
select *
from o1 left outer join o2 on o1.i = o2.i and o1.j > o2.i order by 1,2,3,4;
select *
from o1 left outer join o2 on o1.i = o2.i and o1.j < o2.i order by 1,2,3,4;
select *
from o1 left outer join o2
on o1.i = o2.i and o1.j*2 = o2.j	/* OK */
order by 1, 2, 3, 4;
select *
from o1 left outer join o2
on o1.i < o2.i and o1.j*2 = o2.j	/* XASL generation error -> OK */
order by 1, 2, 3, 4;
select *
from o1 left outer join o2
on o1.i = o2.i and o1.j = o2.j/2     	/* OK */
order by 1, 2, 3, 4;
select *
from o1 left outer join o2
on o1.i < o2.i and o1.j = o2.j/2     	/* core dump -> OK */
order by 1, 2, 3, 4;
select *
from o1 right outer join o2 on o1.i = o2.i
order by o2.i ;
select *
from o1 right outer join o2 on o1.j = o2.j
order by o2.i ;
select *
from o1 right outer join o2 on o1.i = o2.i and o1.j = o2.j
order by o2.i ;
select *
from o1 right outer join o2 on o1.i = o2.i and o1.j > o2.i
order by o2.i ;
select *
from o1 right outer join o2 on o1.i = o2.i and o1.j < o2.i
order by o2.i ;
select *
from o1 right outer join o2
on o1.i = o2.i and o1.j*2 = o2.j 	/* OK */
order by o2.i ;
select *
from o1 right outer join o2
on o1.i < o2.i and o1.j*2 = o2.j 	/* XASL generation error -> OK */
order by o2.i ;
select *
from o1 right outer join o2
on o1.i = o2.i and o1.j = o2.j/2      /* OK */
order by o2.i ;
select *
from o1 right outer join o2
on o1.i < o2.i and o1.j = o2.j/2      /* core dump -> OK */
order by o2.i ;
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t1.i = t3.i			/* (t1 L t2) L t3 */
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t1.i = t3.j			/* (t1 L t2) L t3 */
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t1.i = t3.i and t1.j = t3.j	/* (t1 L t3) L t2 */
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i and t1.j = t2.j
left outer join o1 t3 on t1.i = t3.i and t1.j = t3.j	/* (t1 L t2) L t3 */
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i and t1.j*2 = t2.j
left outer join o1 t3 on t1.i = t3.i and t1.j = t3.j	/* (t1 L t2) L t3 */
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t2.i = t3.i and t2.j = t3.j	/* (t1 L t2) L t3 */
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i and t1.j = t2.j
left outer join o1 t3 on t2.i = t3.i and t2.j = t3.j	/* (t1 L t2) L t3 */
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i and t1.j*2 = t2.j
left outer join o1 t3 on t2.i = t3.i and t2.j = t3.j	/* (t1 L t2) L t3 */
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t1.i = t3.i and t2.j = t3.j	/* (t1 L t2) L t3 */
order by t1.i
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i
right outer join o1 t3 on t1.i = t3.i;			/* (t1 R t2) R t3 */
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i
right outer join o1 t3 on t1.i = t3.i and t1.j = t3.j;	/* t3 L (t1 R t2) */
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i
right outer join o1 t3 on t2.i = t3.i and t2.j = t3.j	/* t3 L (t1 R t2) */
order by t3.i, t3.j
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i and t1.j*2 = t2.j
right outer join o1 t3 on t1.i = t3.i;			/* (t2 L t1) R t3 */
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i and t1.j*2 = t2.j
right outer join o1 t3 on t1.i = t3.i and t1.j = t3.j;	/* t3 L (t2 L t1) */
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i and t1.j*2 = t2.j
right outer join o1 t3 on t2.i = t3.i and t2.j = t3.j	/* t3 L (t2 L t1) */
order by t3.i, t3.j
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
right outer join o1 t3 on t1.i = t3.i;			/* (t1 L t2) R t3 */
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i and t1.j = t2.j
right outer join o1 t3 on t1.i = t3.i;			/* (t1 L t2) R t3 */
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
right outer join o1 t3 on t1.i = t3.i and t1.j = t3.j;	/* t3 L (t1 L t2) */
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i and t1.j = t2.j
right outer join o1 t3 on t1.i = t3.i and t1.j = t3.j;	/* t3 L (t1 L t2) */
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t1.i = t3.i 			/* (t1 R t2) L t3 */
order by t2.i ;
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i and t1.j = t2.j
left outer join o1 t3 on t1.i = t3.i 			/* (t2 L t1) L t3 */
order by t2.i ;
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t1.i = t3.i and t1.j = t3.j 	/* (t1 L t3) R t2 */
order by t2.i ;
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i and t1.j = t2.j
left outer join o1 t3 on t1.i = t3.i and t1.j = t3.j 	/* (t2 L t1) L t3 */
order by t2.i ;
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t1.i = t3.i and t1.j = t3.j
left outer join o2 t4 on t1.i = t4.i 			-- ((t1 L t3) L t4) L t2
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t1.i = t3.i and t1.j = t3.j
left outer join o2 t4 on t1.i = t4.i and t1.j = t4.j	-- ((t1 L t3) L t4) L t2
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t2.i = t3.i and t2.j = t3.j
left outer join o2 t4 on t3.i = t4.i and t3.j = t4.j	-- ((t1 L t2) L t3) L t4
order by t1.i
select *
from o1 t1 left outer join o2 t2 on t1.i = t2.i
left outer join o1 t3 on t2.i = t3.i and t2.j = t3.j
left outer join o2 t4 on t1.i = t4.i and t1.j = t4.j	-- ((t1 L t2) L t3) L t4
order by t1.i
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i
right outer join o1 t3 on t1.i = t3.i and t1.j = t3.j
right outer join o2 t4 on t1.i = t4.i 			-- t3 L (t1 R t2) R t4
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i
right outer join o1 t3 on t1.i = t3.i and t1.j = t3.j
right outer join o2 t4 on t1.i = t4.i and t1.j = t4.j;	-- t4 L (t3 L (t1 R t2))
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i
right outer join o1 t3 on t2.i = t3.i and t2.j = t3.j
right outer join o2 t4 on t3.i = t4.i and t3.j = t4.j 	-- t4 L (t3 L (t1 R t2))
order by t4.i ;
select *
from o1 t1 right outer join o2 t2 on t1.i = t2.i
right outer join o1 t3 on t2.i = t3.i and t2.j = t3.j
right outer join o2 t4 on t1.i = t4.i and t1.j = t4.j	-- t4 L (t3 L (t1 R t2))
order by t4.i
rollback work;
rollback;
