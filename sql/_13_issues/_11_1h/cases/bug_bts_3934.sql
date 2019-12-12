create table u (i int, j int);
insert into u values (0,0), (1,0), (0,1), (1,1);

select * from u where if((i <> 0),1,99) = 1 order by 1,2;
select * from u where if((i <> 0) and (j <> 0),1,99) = 1 order by 1,2;
drop table u;
