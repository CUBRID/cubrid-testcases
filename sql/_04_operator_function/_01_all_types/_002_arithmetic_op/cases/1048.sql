--[er]test '/' operator by smallint field divede int zero field

create class func_02 ( a smallint, b int, c numeric(38,10), d float, e monetary, f double );
insert into func_02 values ( 0,0,0,0,0,0);
insert into func_02(a) values ( null);
insert into func_02 values ( 1,1,1,1,1,1);
insert into func_02 values ( 127,10000,987654321.123456789,987654321.123,987654321.987,987654321.123);
insert into func_02 values (-127,-10000,-987654321.123456789,-987654321.123, -987654321.987,-987654321.123);

select a/b from func_02 order by 1;

drop class func_02;
