--TEST: Throw "ERROR: Execute: Query execution failure #1563. " when execute "select char_length( format( cast('nan' as double), 2))>0;"


select  char_length( format( cast('nan' as double), 2))>0;

set names iso88591;
select  char_length( format( cast('nan' as double), 2))>0;
select  char_length( format( cast('nan' as double), 2))>0;
select  char_length( format( cast('nan' as double), 2))>0;

set names utf8;
select  char_length( format( cast('nan' as double), 2))>0;
select  char_length( format( cast('nan' as double), 2))>0;
select  char_length( format( cast('nan' as double), 2))>0;

set names euckr;
select  char_length( format( cast('abc' as int), 2))>0;
select  char_length( format( cast('abc' as int), 2))>0;
select  char_length( format( cast('abc' as int), 2))>0;


set names iso88591;
