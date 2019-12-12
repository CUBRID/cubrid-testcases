-- tests length of varchar with some select statements.
create class a ( id2 varchar(9) );
insert into a values('ddddd ');

select id2, length(id2) from a where id2='ddddd' ;
select id2, length(id2) from a where id2='ddddd ' ;
select length(id2), length('ddddd') from a where length(id2) = length('ddddd') ;
select length(id2), length('ddddd') from a where length(id2) = length('ddddd ') ;
select id2, length(id2) from a where id2='ddddd' and length(id2) = length('ddddd ') ;
select id2, length(id2) from a where id2='ddddd ' and length(id2) = length('ddddd ') ;
select id2, length(id2) from a where id2='ddddd' and length(id2) = length('ddddd') ;


drop a;