select '1',2,3 union all select 4,'5',6 union all select 7,8,'9';
values('1',2,3),(4,'5',6),(7,8,'9');

select 1,2,3 union all select 4.0,'5',6 union all select 7,8,time '13:20:32';
values(1,2,3),(4.0,'5',6),(7,8,time '13:20:32');

select 1,2,3 union all values(4,5,6) union all values(7,8,time '9');
select '1',2,3 union all values(4,'5',6) union all values(7,8,time '9');

values(4,5,6) union all values(7,8,9) union all select 1,2,3;
values(4,'5',6) union all values(7,8,time '9') union all select '1',2,3;

values(1,2,3),(4,5,6),(7,8,9);
values(1,2,3),(4,4.0,6),(7,8,time '9');
values('1',2,3),(4,4.0,6),(7,8,time '9');

values(1,2,3),(4,5,6),(7,8,9) union values(1,2,3),(7,8,9);
values(1,2,3),(4,5,6),(7,8,9) union values(1,2,3),(7,8,'9');
select 4,5,6 union select 7,8,9 union values(7,8,'9');

--more type test
values('2012-10-10','def') union values(datetime '2012-05-10 15:30:59', '2012-05-10');
values(cast(32767 as smallint), cast(2147483647 as int), cast(2147483648 as bigint)) union all values(cast(1.234 as numeric(3,2)), cast(3.402823466e+38 as float),cast(1.797693134862315e+308 as double));
values(cast(32767 as smallint)), (cast(2147483647 as int)), (cast(2147483648 as bigint)) union all values(cast(1.234 as numeric(3,2))), (cast(3.402823466e+38 as float)),(cast(1.797693134862315e+308 as double));

values(cast(32767 as smallint)), (cast(2147483647 as int)), (cast(2147483648 as bigint)) union all values(cast(1.234 as numeric(3,2))), (cast(3.402823466e+38 as float)) union all select cast(1.797693134862315e+308 as double);
values(cast(12345.67898923 as monetary)) union all values(9876543210);
values(cast(12345.67898923 as monetary)) union all select 9876543210;

values(date '12/31/9999') union all values('0001-01-01');
values('12/31/9999') union all values(date '0001-01-01');

values(time '23:59:59') union all values(3661 + time '2:4:5') union all values(3661);
values(timestamp '12:30:56 05/21/2012' + 3661) union all values(154885965);
values(timestamp '12:30:56 05/21/2012' + 3661) union all values(datetime '23:32:43 09/23/2013');

values(date '12/31/9999') union all select '0001-01-01';
values(time '23:59:59') union all values(3661 + time '2:4:5') union all select 3661;
values(timestamp '12:30:56 05/21/2012' + 3661) union all select 154885965;
values(timestamp '12:30:56 05/21/2012' + 3661) union all select datetime '23:32:43 09/23/2013';

values(B'01010111') union all values(X'ab');
values(B'01010111') union all values(cast('ab' as bit(7)));
values (cast(b'010101111' as bit varying(12))) union all values(X'abcd');
values(B'01') union all values(3);
values(B'01') union all values(cast(3 as bit(2)));


values('abc' 'def') union all values('abc''def');
values('abcdef') union all values(cast('1234567890' as char(5)));
values('abcded') union all values(cast('1234567890' as varchar(7)));
values(length(cast('1234' as char(5)))) union all values(length(cast('1234' as varchar(7))));

--prepare and execute
prepare s from 'values(?),(?),(?) union select ?';
execute s using 1,2,3,4;
execute s using 1,2,'3',4;
execute s using 1,2,3,'4';
execute s using 1.0,2,3,4;
execute s using 1,2,3,4.0;
execute s using 1,2,3,time '0:0:4';

prepare s from 'values(?),(?),(?) union values(?),(?)';
execute s using 1,2,3,4,5;
execute s using 1,'2',3,4,5;
execute s using 1,2,3,4,'5';

prepare s from 'values(?,1),(?,2) union all values(1,2),(3,4)';
execute s using 1,2;
prepare s from 'values(1,2),(3,4) union all values(?,1),(?,2)';
execute s using 1,2;
prepare s from 'values(?,2),(?,4) union all values(?,1),(?,2)';
execute s using 1,2,3,4;

deallocate prepare s;

