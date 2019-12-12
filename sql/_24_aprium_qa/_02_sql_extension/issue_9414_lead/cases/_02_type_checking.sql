--  scenario
create table tc (vi int, vd double, vc char(20), vvc varchar(15));
insert into tc values (1, 1.1, '1', '1');
insert into tc values (1, 1.1, '1', '1');
insert into tc values (1, 1.1, '1', '1');
insert into tc values (2, 2.2, '2', '2');
insert into tc values (2, 2.2, '2', '2');
insert into tc values (2, 2.2, '2', '2');
insert into tc values (2, 2.2, 'qx', 'zf');
insert into tc values (3, 3.3, '3', '3');
insert into tc values (3, 3.3, '3', '3');
insert into tc values (3, 3.3, '3', '3');

-- simple coercion fails
select lead (vi, 1, 'x') over (order by vi) from tc;
select lead (vi, 'h', NULL) over (order by vi) from tc;
select lead (vi, 'h', 'x') over (order by vi) from tc;

-- simple coercion success
select lead (vi, 1, '-1') over (order by vi) from tc;
select lead (vi, '2', NULL) over (order by vi) from tc;
select lead (vi, '2', '-1') over (order by vi) from tc;
select lead (vi, 2.2, -1.1) over (order by vi) from tc;

-- mixed types
select lead (if(vi mod 2 = 0, vd, vvc)) over (order by vi) from tc;
select lead (if(vi mod 2 = 0, vd, vvc), case vi when 1 then 0 when 2 then '1' when 2 then '3.3' end) over (order by vi) from tc;
select lead (vi, 100, case vi when 1 then '1.1' when 2 then 2 when 3 then NULL end) over (order by vi) as lng from tc;
select lead (vvc, 100, case vi when 1 then NULL when 2 then 'y' when 3 then 'z' end) over (order by vi) as lng from tc;

-- cleanup
drop table tc;
