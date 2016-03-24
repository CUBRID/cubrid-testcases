--[er]compare two bit data type value by wrong comparison operators '=<'

create class func_01 ( a bit(8), b bit(8), c bit(1), d bit varying(8));
insert into func_01 values ( B'11111111', B'11111111', B'1', B'11111111');
insert into func_01 values ( B'1111', B'11111111', B'1', B'00000000');
insert into func_01 values ( B'11110000', B'11111111', B'1', B'1111');
insert into func_01 values ( B'00001111', B'11111111', B'1', B'0000');
insert into func_01 values ( B'10101010', B'11111111', B'1', B'1');
insert into func_01 values ( B'1', B'11111111', B'1', B'0');
insert into func_01 values ( B'0', B'11111111', B'1', B'10');
insert into func_01 values ( null, B'11111111', B'1', B'');
insert into func_01 values ( B'', B'11111111', B'1', null);
insert into func_01 values ( B'0000', B'11111111',null, B'00001111');

select a, b from func_01 where a =< b  order by 1,2;

drop class func_01;
