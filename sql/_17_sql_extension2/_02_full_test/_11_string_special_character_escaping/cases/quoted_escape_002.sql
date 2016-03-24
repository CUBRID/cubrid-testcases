--+ holdcas on;
--test a ' inside a string quoted with ' 
--test a " inside a string quoted with " 
--test a ' inside a string quoted with "
--test a " inside a string quoted with ' 


set system parameters 'ansi_quotes=no';


select 'hello', '"hello"', '""hello""', 'hel''lo', '''hello';

select "hello", "'hello'", "''hello''", "hel""lo", """hello";


--a ' inside a string quoted with ' 
select '''''';
select '''a''';
select '''''a''''';
select '''a''''b''''c''''d''';
--a " inside a string quoted with "
select """";
select """b""";
select """""b""""";
select """a""'b'""c""'d'""""e""""''";
--a ' inside a string quoted with "
select "'";
select "'c'";
select "'c' 'c'";
--a " inside a string quoted with '
select '"';
select '"c"';
select '""c""';




--exceptional cases
select ''';
select """;


set system parameters 'ansi_quotes=yes';





commit;
--+ holdcas off;
