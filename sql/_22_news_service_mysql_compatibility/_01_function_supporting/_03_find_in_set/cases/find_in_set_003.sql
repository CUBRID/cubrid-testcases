--+ holdcas on;
--TEST: pass different values to the 1st param



--TEST: pass char/varchar values to the 1st param
select if(find_in_set('abc', 'a,b,c,abc,bcd') = 4, 'ok', 'nok');
select if(find_in_set('a', 'b,a,c,k,dd') = 2, 'ok', 'nok');
--TEST: pass nchar/nvarchar values to the 1st param
select if(find_in_set(n'abc', 'a,b,c,abc,bcd') = 4, 'ok', 'nok');
select if(find_in_set(n'a', 'b,a,c,k,dd') = 2, 'ok', 'nok');
--TEST: pass nchar/nvarchar values to the 2nd param, char to the 1st param
select if(find_in_set('abc', n'a,b,c,abc,bcd') = 4, 'ok', 'nok');
select if(find_in_set('a', n'b,a,c,k,dd') = 2, 'ok', 'nok');
--TEST: pass nchar/nvarchar values to the 2nd param, nchar to the 1st param
select if(find_in_set(n'abc', n'a,b,c,abc,bcd') = 4, 'ok', 'nok');
select if(find_in_set(n'a', n'b,a,c,k,dd') = 2, 'ok', 'nok');


--TEST: large set of substrings, char to the 1st param
select if(find_in_set('uv', 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,ab,cd,ef,gh,ij,kl,mn,op,qr,st,uv,wx,yz') = 37, 'ok', 'nok');
--TEST: large set of substrings, nchar to the 1st param
select if(find_in_set(n'uv', 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,ab,cd,ef,gh,ij,kl,mn,op,qr,st,uv,wx,yz') = 37, 'ok', 'nok');
--TEST: large set of substrings, char to the 1nd param, nchar to the 2nd
select if(find_in_set('uv', n'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,ab,cd,ef,gh,ij,kl,mn,op,qr,st,uv,wx,yz') = 37, 'ok', 'nok');
--TEST: large set of substrings, nchar to the 1st param, nchar to the 2nd
select if(find_in_set(n'uv', n'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,ab,cd,ef,gh,ij,kl,mn,op,qr,st,uv,wx,yz') = 37, 'ok', 'nok');


--TEST: pass numeric value to the 1st param
select if(find_in_set(1, '1,2,3,4,5') = 1, 'ok', 'nok');
select if(find_in_set(2, '1,2,3,4,5') = 2, 'ok', 'nok');
select if(find_in_set(3, '1,2,3,4,5') = 3, 'ok', 'nok');
select if(find_in_set(4, '1,2,3,4,5') = 4, 'ok', 'nok');
select if(find_in_set(5, '1,2,3,4,5') = 5, 'ok', 'nok');
select if(find_in_set(12, '23,34,678,908,12,345') = 5, 'ok', 'nok');
--TEST: float number
select if(find_in_set(1.2, '23,34,678,908,1.2,345') = 5, 'ok', 'nok');
--TEST: negative numer
select if(find_in_set(-3, '-1,-2,-3,-4,-5') = 3, 'ok', 'nok');



--TEST: pass bit value to the 1st param
select if(find_in_set(B'11', '1,2,3,4') = 0, 'ok', 'nok');


--TEST: quotation makrs in the substrings
set system parameters 'ansi_quotes=no';
select if(find_in_set('a', "'b','e','a'") = 0, 'ok', 'nok');
select if(find_in_set('a', "'b','e',a") = 3, 'ok', 'nok');
select if(find_in_set("'a'", "'b','e','a'") = 3, 'ok', 'nok');
select if(find_in_set("'a'", "'b','e',a") = 0, 'ok', 'nok');
select find_in_set('a', ''b','e','a'');

set system parameters 'ansi_quotes=yes';



commit;
--+ holdcas off;
