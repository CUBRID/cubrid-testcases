drop table if exists t1;
create table t1(id int ,i int,j bigint,k float);
insert into t1 values(1,4,9,null),(1,8,6,0),(1,3,7,1),(1,null,13,2),(1,5,null,3);
insert into t1 values(2,5,10,null),(2,9,7,1),(2,4,8,2),(2,null,14,3),(2,6,null,4);

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
) select * from avg_i,avg_j,avg_k where avg_i.id=avg_k.id and avg_j.id=avg_i.id;

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
update t1 set id=id+1
where i>( select avg_i from avg_i where avg_i.id=t1.id )
and j< ( select avg_j from avg_j where avg_j.id=t1.id )
and k< ( select avg_k from avg_k where avg_k.id=t1.id );

select * from t1 where i=8 or i=9;

