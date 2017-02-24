with cte1(a) as (select 1 a),    
cte2(a) as (select a + 1 from cte1)   select *from cte1 join cte2 on 1=2 union all select *, 11 from cte2;

with cte1(a) as (select 1 a),                                                                                                                cte2(a) as (select a + 1 from cte1) select *, (select 111 ) b from cte1 join cte2 on 1=2 union all (select * from (select * from cte1) as a, (select * from cte2) as b, (select 1111));

with cte1(a) as (select 1 a),                                                                                                                cte2(a) as (select a + 1 from cte1) select *, (select 111 ) b from cte1 join cte2 on 1=1 union all (select * from (select * from cte1) as a, (select * from cte2) as b, (select 1111)) order by 1,2;

with cte1(a) as (select 1 a),                                                                                                                cte2(a) as (select a + 1 from cte1) select *, (select 111 ) b from cte1 join cte2 on 1=2 difference (select * from (select * from cte1) as a, (select * from cte2) as b, (select 1111));

with cte1(a) as (select 1 a),                                                                                                                cte2(a) as (select a + 1 from cte1) select *, (select 111 ) b from cte1 join cte2 on 1=2 intersection (select * from (select * from cte1) as a, (select * from cte2) as b, (select 1111)); 

with cte1(a) as (select 1 a),                                                                                                                cte2(a) as (select a + 1 from cte1) select *, (select 111 ) b from cte1 join cte2 on 1=1 intersection (select * from (select * from cte1) as a, (select * from cte2) as b, (select 1111));

with cte1(a) as (select 1 a),                                                                                                                cte2(a) as (select a + 1 from cte1) select *, (select 111 ) b from cte1 join cte2 on 1=1 difference (select * from (select * from cte1) as a, (select * from cte2) as b, (select 1111));
