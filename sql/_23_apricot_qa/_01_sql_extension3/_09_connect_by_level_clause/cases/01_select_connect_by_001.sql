select level 
from (select 1 as dual) as dual
connect by level <= 10;

select count(*) from (SELECT LEVEL  
from (select 1 as dual) as dual
CONNECT BY level<='0x1abe');

select count(*) from (SELECT LEVEL  
from (select 1 as dual) as dual
CONNECT BY level<='0x1abe'-1);

select count(*) from (SELECT LEVEL  
from (select 1 as dual) as dual
CONNECT BY level<='0x1abe'-'0x1abf');

select count(*) from (SELECT LEVEL  
from (select 1 as dual) as dual
CONNECT BY level<=0x1ab a);

select count(*) from (SELECT LEVEL  
from (select 1 as dual) as dual
CONNECT BY level<=b'111'); 

select count(*) from (SELECT LEVEL  
from (select 1 as dual) as dual
CONNECT BY level<=b111); 