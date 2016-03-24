--+ holdcas on;
set names binary;

SELECT RPAD ('CUBRID', 3, '?'),length(RPAD ('CUBRID', 3, '?'));
SELECT RPAD ('큐브리드', 4, '?'),length(RPAD('큐브리드', 4, '?'));
SELECT RPAD ('CUBRID', 10),length(RPAD('CUBRID', 10));
SELECT RPAD ('CUBRID', 10, '?'),length(RPAD('CUBRID', 10, '?'));
SELECT RPAD ('큐브리드', 10, '?'),length(RPAD('큐브리드', 10, '?'));
SELECT RPAD ('큐브리드', LENGTH('큐브리드')+4, '?'),length(RPAD('큐브리드', LENGTH('큐브리드')+4, '?'));
SELECT RPAD (cast( _utf8'큐브리드'as string charset euckr), 10, '?'),length(RPAD(cast( _utf8'큐브리드'as string charset euckr), 10, '?'));
 
SELECT RPAD ('CUBRID', 3, '?'),length(RPAD('CUBRID', 3, '?'));
SELECT RPAD ('你好我好大家好', 3, '?'),length(RPAD('你好我好大家好', 3, '?'));
SELECT RPAD ('你好我好大家好', 30, '?'),length(RPAD('你好我好大家好', 30, '?'));
SELECT RPAD ('CUBRID', 10),length(RPAD('CUBRID', 10));
SELECT RPAD ('CUBRID', 10, '?'),length(RPAD('CUBRID', 10, '?'));
SELECT RPAD ( '큐브리드', 10, '드'),length(RPAD ( '큐브리드', 10, '드'));


set names iso88591;
--+ holdcas off;
