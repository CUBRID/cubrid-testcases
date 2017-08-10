--+ holdcas on;
-- error cases
--drop y;
create class y (a int, b clob, c string);
insert into y values (1, char_to_clob('test1'), 'test1');
insert into y values (2, char_to_clob('test2'), 'test2');
insert into y values (3, char_to_clob('test3'), 'test3');

-- select, aggregation
-- error
select sum(b) from y; 
-- select, order by
-- error
select * from y order by b; 
-- select, group by
-- error
select count(*) from y group by b; 
-- select, is null
select * from y where b is null;
-- select, comparisons
-- error
select * from y where b = char_to_clob('test'); 
select * from y where clob_to_char(b) = 'test'; 
-- error
select * from y where b = 'test'; 
-- error
select * from y where b <> 'test'; 

delete from y;
drop y;
commit;
--+ holdcas off;
