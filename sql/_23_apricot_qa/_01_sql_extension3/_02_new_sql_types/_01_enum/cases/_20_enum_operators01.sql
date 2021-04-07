--logical and comparison operators with enum type column and constant values


create table oper(id bigint unique auto_increment, t enum('100', '123.45678', 'cubrid', '12:12:12', '2000-10-10', '1998-10-10 12:12:12', '12:12:12 10/10/1998', '18') default 3);

insert into oper(t) values(1), (2), (default), (4), (5), (6), (7), (8), (null), (null);

--TEST: enum type with logical operators
select if ((t&&t)=1, 'ok', 'nok') from oper where t is not null;
select if((t or 9999999)=1, 'ok', 'nok') from oper where t is not null;
select if((t or false)=1, 'ok', 'nok') from oper where t is not null;
select if((t & null) is null, 'ok', 'nok') from oper;
select if((t xor 1)=0, 'ok', 'nok') from oper where t='100'; 
select if((t xor 0)=1, 'ok', 'nok') from oper where t is not null;
select if((!t)=0, 'ok', 'nok') from oper where t is not null;


--create index
create index i on oper(t);

--TEST: comparison operators, compare with numeric value
select /*+ RECOMPILE */ * from oper where t < 3 order by 1;
select /*+ RECOMPILE */ * from oper where t > 4.56789 order by 1;
select /*+ RECOMPILE */ * from oper where t <= '100' and t >= 2.2222222 order by 1;
select /*+ RECOMPILE */ * from oper where t != 5 and t < 10 order by 1;
select /*+ RECOMPILE */ * from oper where t > floor(4.09877) order by 1;
--TEST: index should be used
select /*+ RECOMPILE */ * from oper where t = 3 order by 1;
select /*+ RECOMPILE */ * from oper where t in (3, 5, 7, 9) order by 1;
select /*+ RECOMPILE */ * from oper where t in (1, 2, 4, 8) order by 1;
--TEST: no matched rows 
select /*+ RECOMPILE */ * from oper where t = 100 order by 1;

--TEST: comparison operators, compare with string value
select /*+ RECOMPILE */ * from oper where t is null order by 1;
select /*+ RECOMPILE */ * from oper where t <> '100' and id < 4 order by 1;
select /*+ RECOMPILE */ * from oper where t > '22222' and t < 'ddddd' order by 1;
select /*+ RECOMPILE */ * from oper where t <= '18' order by 1;
--TEST: index should be used
select /*+ RECOMPILE */ * from oper where t = '123.45678' order by 1;
select /*+ RECOMPILE */ * from oper where left(t, 3)=left('cub123', 3) order by 1;
select /*+ RECOMPILE */ * from oper where t in ('a', 'b', 'cubrid', '1', '100', '18', 'c') order by 1;
select /*+ RECOMPILE */ * from oper where t > '1' and t='abc' order by 1;

--TEST: comparison operators, compare with date/time value
select /*+ RECOMPILE */ * from oper where t > time'12:12:11' and id >3 and id < 8 order by 1;
select /*+ RECOMPILE */ * from oper where t <= date'2000-10-12' and id > 3 and id < 8 order by 1;
select /*+ RECOMPILE */ * from oper where t != datetime'12:12:12 10/10/1998' order by 1;
--TEST: index shoule be used
select /*+ RECOMPILE */ * from oper where t = timestamp'1998-10-10 12:12:12' order by 1;
select /*+ RECOMPILE */ * from oper where t in (time'12:12:12', date'2000-10-10', timestamp'1998-10-10 12:12:12', datetime'12:12:12 10/10/1998') order by 1;

--TEST: comparison operators, compare with bit value
select /*+ RECOMPILE */ * from oper where t <= X'10' and t is not null order by 1;
select /*+ RECOMPILE */ * from oper where t > cast(X'11' as bit varying) order by 1;
--TEST: index should be used
select /*+ RECOMPILE */ * from oper where t = X'18' order by 1;
select /*+ RECOMPILE */ * from oper where t in (X'18', X'100') order by 1;

--TEST: mix
select /*+ RECOMPILE */ * from oper where t < 6 and t > time'11:11:11' order by 1;
select /*+ RECOMPILE */ * from oper where t != X'17' and t < 'aaa' order by 1;


drop table oper;


