--TEST: large number of substrings in the string list on server side


create table f09(a varchar);
insert into f09 values('a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,ab,cd,ef,gh,ij,kl,mn,op,qr,st,uv,wx,yz,abc,def,ghi,jkl,mno,pqr,stu,vwx,yza,bcd,efg,hij,klm,nop,qrs,tuv,wxy,zabc,defg,hijk,lmno,pqrs,tuvw,xyza,bcde,fghi,jklm,nopq,rstu,vwxy,za,bc,de,fg,hi,jk,lm,no,pq,rs,tu,vw,xy,zab,cde,fgh,ijk,lmn,opq,rst,uvw,xyz,abcde,fghij,klmno,pqrst,uvwxy,zabcd,efghi,jklmn,opqrs,tuvwx,yza,bcd,efg,hij,klm,nop,qrs,tuv,wxy,zabcd,efghi,jklmn,opqrs,tuvwx,yzabc,defgh,ijklm,nopqr,stuvw,xyzab,cdefg,hijkl,mnopq,rstuv,wxyza');


--TEST: server side
select find_in_set('a', a) result, if(find_in_set('a', a) = 1, 'ok', 'nok') from f09;

--TEST: server side
select find_in_set('uv', a) result, if(find_in_set('uv', a) = 37, 'ok', 'nok') from f09;

--TEST: server side
select find_in_set('pqrs', a) result, if(find_in_set('pqrs', a) = 61, 'ok', 'nok') from f09;

--TEST: server side
select find_in_set('zab', a) result, if(find_in_set('zab', a) = 83, 'ok', 'nok') from f09;

--TEST: server side
select find_in_set('uvwxy', a) result, if(find_in_set('uvwxy', a) = 96, 'ok', 'nok') from f09;

--TEST: server side
select find_in_set('yza', a) result, if(find_in_set('yza', a) = 48, 'ok', 'nok') from f09;

--TEST: server side
select find_in_set('wxyza', a) result, if(find_in_set('wxyza', a) = 0, 'ok', 'nok') from f09;


drop table f09;


--TEST: long string to the 1st param
create table f09(a varchar, b char(1024));
insert into f09 values('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'a,b,c,d,eeeeeeeeee,ffffffffffffffffffffffffffff,aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa,gggggggggg,kkk');

--TEST: on server side
select find_in_set(a, b) result, if(find_in_set(a, b) = 7, 'ok', 'nok') from f09;


drop table f09;

