autocommit off;
select a                            from
	table(set(select d from inventory_v2 d)) as t(a) order by a;
select a, a.p                    from 
	table(set(select d from inventory_v2 d)) as t(a) order by a, a.p  ;
select a, a.p, a.p.descr  from 
	table(set(select d from inventory_v2 d)) as t(a)  order by a, a.p, a.p.descr desc;
rollback;
