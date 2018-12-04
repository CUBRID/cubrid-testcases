drop table if exists t1,foo;
create table t1(id int ,i int,j bigint,k float);
insert into t1 values(1,4,9,null),(1,8,6,0),(1,3,7,1),(1,null,13,2),(1,5,null,3);
insert into t1 values(2,5,10,null),(2,9,7,1),(2,4,8,2),(2,null,14,3),(2,6,null,4);

create table foo as
with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
) select avg_i.id as id,avg_i,avg_j,avg_k  from avg_i,avg_j,avg_k where avg_i.id=avg_j.id and avg_j.id=avg_k.id;

select * from foo order by 1;

alter table foo change column id id int unique not null; 

insert into foo
with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
) select avg_i.id,avg_i,avg_j,avg_k  from avg_i,avg_j,avg_k where avg_i.id=avg_j.id and avg_j.id=avg_k.id;

select * from foo order by 1;


replace into foo
with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
) select avg_i.id,avg_i,avg_j,avg_k  from avg_i,avg_j,avg_k where avg_i.id=avg_j.id and avg_j.id=avg_k.id;

select * from foo order by 1;

with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
) update t1,avg_i,avg_j,avg_k 
set t1.id=t1.id+100
where t1.id=avg_i.id and avg_i.id=avg_j.id and avg_j.id=avg_k.id
and t1.i<avg_i.avg_i 
and t1.j<avg_j.avg_j
and t1.k<avg_k.avg_k;

select * from t1 where id>100 order by 1,2,3,4;

with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
) delete t1 from t1,avg_i,avg_j,avg_k
where t1.id=avg_i.id and avg_i.id=avg_j.id and avg_j.id=avg_k.id
and (t1.i>avg_i.avg_i
or t1.j>avg_j.avg_j
or t1.k>avg_k.avg_k);

select * from t1  order by 1,2,3,4;

with cte as
( select * from t1 where k is null or j is null or i is null)
delete from t1 where id in (select id from cte);
select * from t1 order by 1,2,3,4;


insert into foo
with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
) select avg_i.id,avg_i,avg_j,avg_k  from avg_i,avg_j,avg_k where avg_i.id=avg_j.id and avg_j.id=avg_k.id;

select * from foo order by 1,2,3,4;

drop table if exists t1,foo;
create table t1(id int ,i int,j bigint,k float);
insert into t1 values(1,4,9,null),(1,8,6,0),(1,3,7,1),(1,null,13,2),(1,5,null,3);
insert into t1 values(2,5,10,null),(2,9,7,1),(2,4,8,2),(2,null,14,3),(2,6,null,4);
create table foo as
with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
)
select * from t1
where i>( select avg_i from avg_i where avg_i.id=t1.id )
and j< ( select avg_j from avg_j where avg_j.id=t1.id )
and k< ( select avg_k from avg_k where avg_k.id=t1.id );

select * from foo order by id;


insert into foo
with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
)
select * from t1
where i>( select avg_i from avg_i where avg_i.id=t1.id )
and j< ( select avg_j from avg_j where avg_j.id=t1.id )
and k< ( select avg_k from avg_k where avg_k.id=t1.id );

select * from foo order by id;

replace into foo
with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
)
select * from t1
where i>( select avg_i from avg_i where avg_i.id=t1.id )
and j< ( select avg_j from avg_j where avg_j.id=t1.id )
and k< ( select avg_k from avg_k where avg_k.id=t1.id );

select * from foo order by id;


with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
),
cte as
(
select * from t1
where i>( select avg_i from avg_i where avg_i.id=t1.id )
and j< ( select avg_j from avg_j where avg_j.id=t1.id )
and k< ( select avg_k from avg_k where avg_k.id=t1.id )
) delete from foo where exists (select * from cte);
select * from foo order by 1;

insert into foo
with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
)
select * from t1
where i>( select avg_i from avg_i where avg_i.id=t1.id )
and j< ( select avg_j from avg_j where avg_j.id=t1.id )
and k< ( select avg_k from avg_k where avg_k.id=t1.id );


with avg_i as
(
  select id,avg(i) as avg_i from t1 group by id order by id
),
avg_j as
(
  select id,avg(j) as avg_j from t1 group by id order by id
),
avg_k as
(
  select id,avg(k) as avg_k from t1 group by id order by id
),
cte as
(
select * from t1
where i>( select avg_i from avg_i where avg_i.id=t1.id )
and j< ( select avg_j from avg_j where avg_j.id=t1.id )
and k< ( select avg_k from avg_k where avg_k.id=t1.id )
) update foo set id=id+100 where exists (select * from cte);
select * from foo order by 1;

drop table if exists t1,foo;
