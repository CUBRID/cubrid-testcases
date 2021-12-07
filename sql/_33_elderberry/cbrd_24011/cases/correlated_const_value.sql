drop table if exists subquery_big;
create table subquery_big (col_a int, col_b int, col_c int);

select /*+ recompile */ count(*) 
	from (select col_b, avg(col_c) 
		from subquery_big group by col_b) a,(select col_b, min(col_c), max(col_c) 
			from subquery_big where col_b=1 group by col_b
			) b
		where a.col_b=b.col_b;

drop table if exists subquery_big;

