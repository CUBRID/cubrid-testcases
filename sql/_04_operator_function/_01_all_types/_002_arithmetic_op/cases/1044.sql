--[er]test bit data type using bit data type field by(*) bit data type field 

create class func_02 ( a bit(8), b bit(8), c bit(1), d bit varying(8));
insert into func_02 values ( B'11111111', B'11111111', B'1', B'11111111');
insert into func_02 values ( B'1111', B'11111111', B'1', B'00000000');
insert into func_02 values ( B'11110000', B'11111111', B'1', B'1111');
insert into func_02 values ( B'00001111', B'11111111', B'1', B'0000');
insert into func_02 values ( B'10101010', B'11111111', B'1', B'1');
insert into func_02 values ( B'1', B'11111111', B'1', B'0');
insert into func_02 values ( B'0', B'11111111', B'1', B'10');
insert into func_02 values ( null, B'11111111', B'1', B'');
insert into func_02 values ( B'', B'11111111', B'1', null);
insert into func_02 values ( B'0000', B'11111111',null, B'00001111');

select a*b from func_02 order by 1;

drop class func_02;
