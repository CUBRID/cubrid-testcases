--CUME_DIST and PERCENT_RANK functions
create table scores(id int unique auto_increment, 
       	     	    math int, english int, PE char, grade int);

insert into scores(math, english, PE, grade) 
       values(60, 70, 'A', 1), 
       (60, 70, 'A', 1), 
       (60, 80, 'A', 1), 
       (60, 70, 'B', 1), 
       (70, 60, 'A', 1) , 
       (70, 70, 'A', 1) , 
       (80, 70, 'C', 1) , 
       (70, 80, 'C', 1), 
       (85, 60, 'C', 1), 
       (75, 90, 'B', 1);  

insert into scores(math, english, PE, grade) 
       values(95, 90, 'A', 2), 
       (85, 95, 'B', 2), 
       (95, 90, 'A', 2), 
       (85, 95, 'B', 2),
       (75, 80, 'D', 2), 
       (75, 85, 'D', 2),
       (75, 70, 'c', 2), 
       (65, 95, 'A', 2),
       (65, 95, 'A', 2), 
       (65, 95, 'A', 2);

-- Analytic functions
select id, math, english, pe, grade, 
       CUME_DIST() over(order by math, english, pe) as CUME_DIST, 
       PERCENT_RANK() over(order by math, english, pe) as PERCENT_RANK 
       from scores order by CUME_DIST,id;

select id, math, english, pe, grade, 
       CUME_DIST() over(partition by grade order by math asc, english asc, pe asc) as CUME_DIST, 
       PERCENT_RANK() over(partition by grade order by math asc, english asc, pe asc) as PERCENT_RANK 
       from scores order by PERCENT_RANK, id;

-- for desc
select id, math, english, pe, grade, 
       CUME_DIST() over(order by math desc, english) as CUME, 
       PERCENT_RANK() over(order by english desc, pe desc) as PERCENT 
       from scores order by CUME,id;

select id, math, english, pe, grade,
       CUME_DIST() over(order by PE) as CUME, 
       PERCENT_RANK() over(order by PE) as PERCENT 
       from scores order by CUME,id;

select id, math, english, pe, grade, 
       CUME_DIST() over(partition by grade order by math desc, english desc, pe desc) as CUME_DIST, 
       PERCENT_RANK() over(partition by grade order by math desc, english desc, pe desc) as PERCENT_RANK 
       from scores order by CUME_DIST,id;

-- aggregate functions
select CUME_DIST(60, 60, 'D') 
       within group(order by math, english, PE) as CUME
       from scores;

select PERCENT_RANK(100, 100, 'A') 
       within group(order by math, english, PE) as PERCENT
       from scores;


prepare st1 from 'select CUME_DIST(?,?,?) 
	   		within group(order by math, english, PE)
			as CUME from scores';

prepare st2 from 'select PERCENT_RANK(?,?,?) 
	   		within group(order by math, english, PE) 
			as PERCENT from scores';

prepare st3 from 'select CUME_DIST(?) within group(order by math desc) as CUME,
	    	 	 PERCENT_RANK(?,?) within group(order by english, PE) 
			 as PERCENT from scores';



execute st1 using 50, 70, 'A';
execute st1 using 60, 70, 'A';
execute st1 using 75, 80, 'B';
execute st1 using 85, 55, 'D';
execute st1 using 85, 60, 'C';
execute st1 using 85, 65, 'C';
execute st1 using 100, 100, 'A';

execute st2 using 50, 70, 'A';
execute st2 using 60, 70, 'A';
execute st2 using 75, 80, 'B';
execute st2 using 85, 55, 'D';
execute st2 using 85, 60, 'C';
execute st2 using 85, 65, 'C';
execute st2 using 100, 100, 'A';

execute st3 using 50, 50, 'A';
execute st3 using 60, 60, 'A';
execute st3 using 70, 60, 'B';
execute st3 using 75, 70, 'A';
execute st3 using 80, 70, 'C';
execute st3 using 85, 80, 'D';
execute st3 using 90, 85, 'A';
execute st3 using 95, 95, 'A';
execute st3 using 100, 100, 'A';


--special cases:
select CUME_DIST('85',65,'C') 
       within group(order by math, english, PE)
       from scores;

select PERCENT_RANK('100'-10, '80'+'20', 'A')
       within group(order by math, english, PE)
       from scores;

execute st1 using '85', 65, 'C';

select CUME_DIST(2, 70) within group(order by 2, 70) as CUME1,
       CUME_DIST(2, 70) within group(order by 1, english) as CUME2,
       CUME_DIST(2, 70) within group(order by 2, math) as CUME3,
       CUME_DIST(2, 70) within group(order by 3, english) as CUME4,
       CUME_DIST(2, 70) within group(order by '3', '69A') as CUME5,
       CUME_DIST(2, 70) within group(order by '2', '70') as CUME6
       from scores;

select PERCENT_RANK(2, 70) within group(order by 2, 70) as PERCENT1,
       PERCENT_RANK(2, 70) within group(order by 1, english) as PERCENT2,
       PERCENT_RANK(2, 70) within group(order by 2, math) as PERCENT3,
       PERCENT_RANK(2, 70) within group(order by 3, english) as PERCENT4,
       PERCENT_RANK(2, 70) within group(order by '3', '69A') as PERCENT5,
       PERCENT_RANK(2, 70) within group(order by '2', '70') as PERCENT6
       from scores;

-- NULLs value
insert into scores(math, english, PE, grade) 
       values(NULL, 85, 'A', 1),
       (NULL, NULL, 'A', 1),
       (NULL, 95, NULL, 2),
       (NULL, NULL, NULL, 2),
       (NULL, NULL, NULL, NULL);

select id, math, english, pe, grade, 
       CUME_DIST() over(order by math, english, pe) as CUME_DIST, 
       PERCENT_RANK() over(order by math, english, pe) as PERCENT_RANK 
       from scores order by CUME_DIST,id;

select id, math, english, pe, grade, 
       CUME_DIST() over(partition by grade order by math asc, english asc, pe asc) as CUME_DIST, 
       PERCENT_RANK() over(partition by grade order by math asc, english asc, pe asc) as PERCENT_RANK 
       from scores order by PERCENT_RANK, id;

--compatible with ORACLE:
select id, math, english, pe, grade, 
       cume_dist() over(order by math nulls last, english nulls last, pe nulls last) as cume_dist, 
       percent_rank() over(order by math nulls last, english nulls last, pe nulls last) as percent_rank 
       from scores order by cume_dist,id;

select id, math, english, pe, grade, 
       CUME_DIST() over(partition by grade order by math nulls last, english nulls last, 
       		   		  pe nulls last) as CUME_DIST, 
       PERCENT_RANK() over(partition by grade order by math nulls last, english nulls last, 
       		      		  pe nulls last) as PERCENT_RANK 
       from scores order by PERCENT_RANK, id;

select CUME_DIST() over(partition by grade order by math asc nulls last) as CUME_DIST 
       from scores order by CUME_DIST; 

select PERCENT_RANK() over(partition by grade order by pe desc nulls last) as PERCENT 
       from scores order by PERCENT; 


select cume_dist(100) within group(order by math nulls first) as cume from scores;
select cume_dist(100) within group(order by math nulls last) as cume from scores;
select cume_dist(null) within group(order by math nulls first) as cume from scores;
select cume_dist(null) within group(order by math nulls last) as cume from scores;

select percent_rank(100) within group(order by math nulls first) as cume from scores;
select percent_rank(100) within group(order by math nulls last) as cume from scores;
select percent_rank(null) within group(order by math nulls first) as cume from scores;
select percent_rank(null) within group(order by math nulls last) as cume from scores;
 
execute st1 using 50, 70, 'A';
execute st1 using NULL, 70, 'A';
execute st1 using 50, NULL, NULL;
execute st1 using NULL, NULL, NULL;


execute st2 using 50, 70, 'A';
execute st2 using NULL, 70, 'A';
execute st2 using 50, NULL, NULL;
execute st2 using NULL, NULL, NULL;


select id, math, english, pe, grade,
       CUME_DIST() over(order by NULL) as CUME,
       PERCENT_RANK() over(order by NULL) as PERCENT 
       from scores order by 1;

--illegals
execute st1 using '85a', 65, 'C';

select CUME_DIST(80) 
       within group(order by PE) as CUME_DIST
       from scores;

select CUME_DIST(80, 20) 
       within group(order by math) as CUME_DIST
       from scores;

select PERCENT_RANK(80) 
       within group(order by math, english) as CUME_DISD
       from scores;

select CUME_DIST(80, '2a') 
       within group(order by math, english) as CUME_DIST
       from scores;

select PERCENT_RANK(70)
       within group(partition by grade) as PERCENT_RANK
       from scores;

select CUME_DIST(english) within group(order by english) as CUME
       from scores;

select id, math, english, pe, CUME_DIST(), PERCENT_RANK() over(partition by grade)
       from scores;

select CUME_DIST(1, 80, 'A') from scores;

select CUME_DIST(1, 80, 'A') within group() from scores;

select CUME_DIST(1, 80, 'A') within group(order by NULL, NULL, NULL) from scores;

select CUME_DIST() over(order by 123) from scores;

select PERCENT_RANK(NULL, 80, 'A') within group(order by NULL, NULL, NULL) from scores;

deallocate prepare st1;
deallocate prepare st2;
deallocate prepare st3;
drop table scores;
