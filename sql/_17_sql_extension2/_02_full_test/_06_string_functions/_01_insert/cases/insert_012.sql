--exceptional cases


--null
select insert(null, 4, 10, 'abc');
select insert('abcd', null, 5, 'kkk');
select insert('abcd', 2, null, 'kkk');
select insert('abcd', 2, 2, null);


--pass nothing to one of the parameters
select insert(, 4, 10, 'abc');
select insert('abcd', , 5, 'kkk');
select insert('abcd', 2, , 'kkk');
select insert('abcd', 2, 2, );


--pass empty string to the 1st or the 4th paramter
select insert('', 1, 2, 'abc');
select insert('', 2, 5, 'kkk');
select insert('abcd', 2, 2, '');


--pass space to the 1st or the 4th parameter
select insert(' ', 2, 1, 'aaaa');
select insert('bbbb', 1, 2, ' ');


--unmatched format
select insert(date'aaa', 4, 10, 'abc');
select insert(time'abcd', 2, 5, 123);


--wrong number of params
select insert('abcd', 2, 3);
select insert('abcd', 2);
select insert('abcd');
select insert('abcd', 2, 2, 'kkk', 3);
select insert();
select insert(null);


select insert('', -123121, 2, 'abc');
select insert('', 1, -2, 'abc');
select insert('aa', 89128391021, 2, 'abc');
select insert('aa', 1, 1234123412342, 'abc');
select insert('bb', 2, -2234342, 'abc');
