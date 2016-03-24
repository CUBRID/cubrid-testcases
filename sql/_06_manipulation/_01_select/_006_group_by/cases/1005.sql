--Test set with group by

select (i+i)-(i+1)*(i+2) from table({1,1,1,2,2,3,3,3,3,10,10,10}) as t(i) group by (i+i)-(i+1)*(i+2); 
select (i+i)*(i+1)*(i+2) from table({1,1,1,2,2,3,3,3,3,10,10,10}) as t(i) group by (i+i)*(i+1)*(i+2); 
select ((((((((((i+1)+1)+1)+1)+1)+1)+1)+1)+1)+1) from table({1,1,1,2,2,3,3,3,3,10,10,10}) as t(i)  
group by ((((((((((i+1)+1)+1)+1)+1)+1)+1)+1)+1)+1);
