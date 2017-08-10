create table i (i int, j int);
create table j (i int, j int);

-- should pass, i and j are class names
select 'should pass';
delete i, j from i, j; 
insert into i values (1, 1), (2, 2);
insert into j values (2, 2), (3, 3);

delete from i, j using i inner join j on i.i = j.j;

select * from i order by 1;
select * from j order by 1;

-- should pass, dot-star, i and j are class names
select 'should pass';
delete i, j from i, j; 
insert into i values (1, 1), (2, 2);
insert into j values (2, 2), (3, 3);

delete from i.*, j.* using i inner join j on i.i = j.j;

select * from i order by 1;
select * from j order by 1;

-- should pass, using aliases
select 'should pass';
delete i, j from i, j; 
insert into i values (1, 1), (2, 2); 
insert into j values (2, 2), (3, 3);

delete from x, y using i x inner join j y on x.i = y.j;

select * from i order by 1; 
select * from j order by 1;

-- should pass, using aliases with star
select 'should pass';
delete i, j from i, j; 
insert into i values (1, 1), (2, 2); 
insert into j values (2, 2), (3, 3);

delete from x.*, y.* using i x inner join j y on x.i = y.j;

select * from i order by 1; 
select * from j order by 1;

-- should fail, specyfing but not using aliases
select 'should fail';
delete i, j from i, j; 
insert into i values (1, 1), (2, 2); 
insert into j values (2, 2), (3, 3);

delete from i, j using i x inner join j y on x.i = y.j;

select * from i order by 1; 
select * from j order by 1;

-- should fail, attribute names not allowed
select 'should fail';
delete i, j from i, j; 
insert into i values (1, 1), (2, 2);
insert into j values (2, 2), (3, 3);

delete from i.i, j.i using i inner join j on i.i = j.j;

select * from i order by 1; 
select * from j order by 1;

-- should fail, attribute names not allowed
select 'should fail';
delete i, j from i, j; 
insert into i values (1, 1), (2, 2); 
insert into j values (2, 2), (3, 3);

delete from x.i, y.i using i x inner join j y on x.i = y.j;

select * from i order by 1;
select * from j order by 1;

-- cleanup
drop table i, j;
