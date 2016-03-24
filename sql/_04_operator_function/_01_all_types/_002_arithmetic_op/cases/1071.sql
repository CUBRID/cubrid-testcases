--[er]test '+' operator by plusing types varchar and integer value

create class func_02 ( a char(8), b char(8), c char(1), d char varying(8), e char varying(8), f string );
insert into func_02 values ('00000000', '11111111','0', '11111111', '11111111', '111122223333' );
insert into func_02 values ('abcdefgh', 'ABCDEFGH','0', 'abcdefgh', 'abcdefgh', '111122223333' );
insert into func_02 values ('abcd', 'ABCD','0', 'abcd', 'abcd', '111122223333' );
insert into func_02 values ('abcd', 'ABCDEFGH','0', 'abcde', 'abcdefgh', '111122223333' );
insert into func_02 values ('', '','0', '', '', '111122223333' );
insert into func_02 values ('1', '0','0', '1', '0', null );
insert into func_02 values ('????', '????','a', '???', '???', '1' );
insert into func_02 values (null, '????','a', null, '???', '' );

select a+b+c+d+e+f+1 from func_02   order by 1;

drop class func_02;
