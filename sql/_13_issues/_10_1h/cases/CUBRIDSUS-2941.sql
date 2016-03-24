SELECT STR_TO_DATE('abc','abc');
SELECT STR_TO_DATE('','vvvvvv');
SELECT STR_TO_DATE('000%%','000%%');
SELECT STR_TO_DATE('abc 4','cde %s');
SELECT STR_TO_DATE('abc 11:33:44 am 19 23:59:59','cde %r %d %T');