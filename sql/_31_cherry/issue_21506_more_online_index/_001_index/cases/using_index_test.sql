--To test cubridsus-1155 cubridsus-1445 cubridsus-1448
create class xoo ( a string, b string, c string);
create index idx1 on xoo (a) with online;
insert into xoo values('UB090427000008', NULL, 'GENERAL');
insert into xoo values('UB090427000011', NULL, 'GENERAL');
insert into xoo values(null, NULL, 'GENERAL');

select * from xoo x, (select * from xoo) y where x.a = y.a or x.a = 'x' order by 1,2,3,4,5,6;

select * from xoo x, (select * from xoo) y where x.a >= y.a or x.a = 'x' order by 1,2,3,4,5,6; 

select * from xoo x, (select * from xoo) y where x.a >= y.a or x.a > 'x'  order by 1,2,3,4,5,6;

select * from xoo x, (select * from xoo) y where x.a between '' and y.a order by 1,2,3,4,5,6; 

select * from xoo x, (select * from xoo) y where y.a between '' and x.a  order by 1,2,3,4,5,6;

select * from xoo x, (select * from xoo) y where x.a = y.a or x.a = 'x' using index x.idx1 order by 1,2,3,4,5,6;

select * from xoo x, (select * from xoo) y where x.a >= y.a or x.a = 'x' using index x.idx1 order by 1,2,3,4,5,6;

select * from xoo x, (select * from xoo) y where x.a >= y.a or x.a > 'x' using index x.idx1 order by 1,2,3,4,5,6;

select * from xoo x, (select * from xoo) y where x.a between '' and y.a using index x.idx1 order by 1,2,3,4,5,6;

select * from xoo x, (select * from xoo) y where y.a between '' and x.a using index x.idx1 order by 1,2,3,4,5,6;





create class yoo ( a char(100), b char(100), c char(100));
create index idx1 on yoo (a) with online;
insert into yoo values('UB090427000008', NULL, 'GENERAL');
insert into yoo values('UB090427000011', NULL, 'GENERAL');
insert into yoo values(null, NULL, 'GENERAL');

select * from yoo x, (select * from yoo) y where x.a = y.a or x.a = 'x'  order by 1,2,3,4,5,6;

select * from yoo x, (select * from yoo) y where x.a >= y.a or x.a = 'x' order by 1,2,3,4,5,6; 

select * from yoo x, (select * from yoo) y where x.a >= y.a or x.a > 'x'  order by 1,2,3,4,5,6;

select * from yoo x, (select * from yoo) y where x.a between '' and y.a order by 1,2,3,4,5,6; 

select * from yoo x, (select * from yoo) y where y.a between '' and x.a  order by 1,2,3,4,5,6;

select * from yoo x, (select * from yoo) y where x.a = y.a or x.a = 'x' using index x.idx1 order by 1,2,3,4,5,6;

select * from yoo x, (select * from yoo) y where x.a >= y.a or x.a = 'x' using index x.idx1 order by 1,2,3,4,5,6;

select * from yoo x, (select * from yoo) y where x.a >= y.a or x.a > 'x' using index x.idx1 order by 1,2,3,4,5,6;

select * from yoo x, (select * from yoo) y where x.a between '' and y.a using index x.idx1 order by 1,2,3,4,5,6;

select * from yoo x, (select * from yoo) y where y.a between '' and x.a using index x.idx1 order by 1,2,3,4,5,6;





create class zoo ( a string, b string, c string);
create index idx1 on zoo (a,b) with online;
create index idx2 on zoo (a) with online;
create index idx3 on zoo (b,a) with online;
insert into zoo values('UB090427000008', NULL, 'GENERAL');
insert into zoo values('UB090427000011', NULL, 'GENERAL');
insert into zoo values(null, '', 'GENERAL');
insert into zoo values(null, NULL, 'GENERAL');
insert into zoo values('', NULL, 'GENERAL');

select * from zoo x, (select * from zoo) y where x.a = y.a or x.a = 'x'  order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a >= y.a or x.a = 'x' order by 1,2,3,4,5,6; 

select * from zoo x, (select * from zoo) y where x.a >= y.a or x.a > 'x'  order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a between '' and y.a order by 1,2,3,4,5,6; 

select * from zoo x, (select * from zoo) y where y.a between '' and x.a  order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a = y.a or x.a = 'x' using index x.idx1 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a >= y.a or x.a = 'x' using index x.idx1 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a >= y.a or x.a > 'x' using index x.idx1 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a between '' and y.a using index x.idx1 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where y.a between '' and x.a using index x.idx1 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a = y.a or x.a = 'x' using index x.idx2 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a >= y.a or x.a = 'x' using index x.idx2 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a >= y.a or x.a > 'x' using index x.idx2 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a between '' and y.a using index x.idx2 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where y.a between '' and x.a using index x.idx2 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a = y.a or x.a = 'x' using index x.idx3 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a >= y.a or x.a = 'x' using index x.idx3 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a >= y.a or x.a > 'x' using index x.idx3 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where x.a between '' and y.a using index x.idx3 order by 1,2,3,4,5,6;

select * from zoo x, (select * from zoo) y where y.a between '' and x.a using index x.idx3 order by 1,2,3,4,5,6;

drop xoo, yoo, zoo;

