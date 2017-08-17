values (1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8),(1),(2),(3),(4),(5),(6),(7),(8);
values (1),(2),(3),(*);
values (1),(2),(3),('*');
values (1),(2),(3),('?');
values (1),(2),(3),('ab');
values ('ab'),(1),(2),(3);
values ('ab'),('123');
values ('1'),('123'),('0x75');
values (1),('123'),('0x75');
values (1),('123'),('0x75'),(b'111111111111');
values ('0x75'),(b'111111111111');
values (1),('123'),(b'111111111111');
values (1),(b'111111111111');
values (b'111111111111');
values ('*');
values ('?');
values ('ab');
values (1 as column1),(2),(3);
values (1 as column1),(2),(3 as column3);
values (1),(2),(3 as column3);

values (1,'name1'),(2,'name2'),(3,'name3');
values (1,'name1'),(2,'name2'),(3,'name3'),(1,'name1'),(2,'name2'),(3,'name3'),(1,'name1'),(2,'name2'),(3,'name3'),(1,'name1'),(2,'name2'),(3,'name3'),(1,'name1'),(2,'name2'),(3,'name3');
values (1,'name1'),(2,'name2'),(3,3);

values (0x74);
values (0x74,0xfe);
values (b'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110');
values (b'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110',0x74);
values (b'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110',0x74,1);
values (b'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110',0x74,1,'ab');
values (b'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110'),(0x74);
values (b'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110'),(0x74),(123);
values (123),(b'11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110'),(0x74);
values (1 as column1,'name1' as column2),(2,'name2'),(3,'name3');
values (2,'name2'),(3,'name3'),(1 as column1,'name1' as column2);
values ('ab','123',123,3);

values (1),('123');
values ('123'),(1);
values ('123'),('abc');
values ('123'),(1),('abc');
values ('123'),('abc'),(1);

values (1+2+3);
values (1+2+3+4*3);
values (1+2+(3+4*3));
values (1+2+(3+4)*3);
values (1-2+(3-4)*3);
values (1-2+(3-4)*3);

values (1+'123');
values (1+'123'+(values(1+'123')));
values (1+'123'+(values(1+2+3)));
values (1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123')))))))))));
values (1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123'+(values(1+'123')))))))))))))))))));


select 1,2,3 into :a,:b,:c;
values (:a),(:b),(:c);

select 1,2,'c' into :a,:b,:c;
values (:a),(:b),(:c);
select (:a),(:b),(:c);
values (:a,:b,:c);

select 1,2,'3' into :a,:b,:c;
values (:a+:b+:c);

select '1','2','3' into :a,:b,:c;
values (:a+:b+:c);

select '1a','2','3' into :a,:b,:c;
values (:a+:b+:c);

select 1,'2','3' into :a,:b,:c;
values (:a+:b+:c);

select 1,'2','0x1' into :a,:b,:c;
values (:a+:b+:c);

select 1,'2','0xf' into :a,:b,:c;
values (:a+:b+:c);

select 1,'2',b'1111' into :a,:b,:c;
values (:a+:b+:c);

select 0xf;
values(0xf);

select (X'f');
values(X'f');

select b'1111';
values(b'1111');

select 0xf+b'1111';
values(0xf+b'1111');

select 0xf+0xf;
values(0xf+0xf);

select b'1111'+b'1111';
values(b'1111'+b'1111');

select 0b1111+0b1111;
values(0b1111+0b1111);

select 0b1111*2;
values(0b1111*2);

select 1+'2'+0xf;
select 1+'2'+b'1111';
select 1+cast(0xf as float);


select 1+'2'+CAST(b'1111' AS float);
select CAST(o'1111' AS float);
select CAST(X'1111' AS int);
select CAST(0x'1111' AS float);
select CAST('0x1111' AS float);
select (b'1111'=X'f');
select CAST('0b1111' AS float);

prepare s from 'values(?),(?),(?)';
execute s using 1,2,'3';

prepare s from 'select ? union select ? union select ?' 
execute s using 1,2,'3';

prepare s from 'select ? union select ? union select ?' 
execute s using 1,2,3;

prepare s from 'values(1+?),(?+2),(?+3)';
execute s using 1,'2',3;

prepare s from 'values(?),(?),(?)';
execute s using 1,2,3;

-- I think these a bug
values(1),(2),('3');
prepare s from 'values(?),(?),(?)';
execute s using 1,2,'3';

deallocate prepare s;
drop variable a,b,c;
