--marginal and out-of-range data test


--pos = 0
select insert('aaa-bbb-ccc-ddd', 0, 5, 'INSERTED');
--len = 0
select insert('aaa-bbb-ccc-ddd', 10, 0, 'INSERTED');
--pos: negative value
select insert('aaa-bbb-ccc-ddd', -12, 5, 'INSERTED');
--marginal
select insert('aaa-bbb-ccc-ddd', 1, 15, 'INSERTED');
--len > the length of the rest of the string
select insert('aaa-bbb-ccc-ddd', 4, 188, 'INSERTED');
--pos > the length of the string
select insert('aaa-bbb-ccc-ddd', 20, 10, 'INSERTED');
--len: negative value
select insert('aaa-bbb-ccc-ddd', 5, -13, 'INSERTED');
--pos: equals to the length of str
select insert('aaa-bbb-ccc-ddd', 15, 6, 'INSERTED');
--pos: equals to the length of str and len is negative
select insert('aaa-bbb-ccc-ddd', 15, -6, 'INSERTED');

