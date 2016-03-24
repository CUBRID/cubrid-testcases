autocommit off;

CREATE  Procedure  ptestint9(i in out string) as language java name 'SpTest5.ptestint2(int[]) ';

select '10' into x from db_root;
call ptestint9(x);
call ptestint9('10');
call ptestint9(null);
$integer,$100;
call ptestint9(?) ;
$varchar,$100;
call ptestint9(?) ;

CREATE Procedure ptestint3(i inout int) as language java name 'SpTest5.ptestint1(int) '; 
call ptestint3(1);
$integer,$1;
call ptestint3(?) ;
drop procedure ptestint3;


CREATE  Procedure  pteststring2(i in out string) as language java name 'SpTest5.pteststring2(java.lang.String[]) ';

select '10' into x from db_root;
call pteststring2(x);
select x from db_root;
call pteststring2('10');
$varchar,$10;
call pteststring2(?) ;
call pteststring2(null);

CREATE  Procedure  pteststring0(a in out string, b in string , c in out string, d in out string, e in out string)
as language java name 'SpTest5.pteststring0(java.lang.String[], java.lang.String[],java.lang.String[],java.lang.String[],java.lang.String[]) ';

select '10', '20', '30', '40', '50' into a, b, c, d, e from db_root;
call pteststring0(a,b,c,d,e);
$varchar,$10,$varchar,$20,$varchar,$30,$varchar,$40,$varchar,$50;
call pteststring0(?,?,?,?,?) ;
drop procedure pteststring0;



CREATE  Procedure  ptestint3(a in out int, b in out int, c in out int, d in out int, e in out int)
as language java name 'SpTest5.ptestint3(int[]) ';

select 10, 20, 30, 40, 50 into a, b, c, d, e from db_root;
call ptestint3(a,b,c,d,e);
call ptestint3(10, 20, 30, 40, 50);
call ptestint3(null, null, null, null, null);
$integer,$10,$integer,$20,$integer,$30,$integer,$40,$integer,$50;
call ptestint3(?,?,?,?,?) ;

------------------------------------------------ ���ڰ� �������� ���
CREATE  Procedure  ptestint4(a in out int, b in out int, c in out int, d in out int, e in out int)
as language java name 'SpTest5.ptestint5(int[], int[],int[],int[],int[]) ';

select 10, 20, 30, 40, 50 into a, b, c, d, e from db_root;
call ptestint4(a,b,c,d,e);
call ptestint4(10, 20, 30, 40, 50);
call ptestint4(null, null, null, null, null);
$integer,$10,$integer,$20,$integer,$30,$integer,$40,$integer,$50;
call ptestint4(?,?,?,?,?) ;

drop procedure pteststring2;

CREATE  Procedure  pteststring2(i in out string) as language java name 'SpTest5.pteststring2(java.lang.String[]) ';

select '10'into x from db_root;
call pteststring2(x);
call pteststring2('10');
$varchar,$10;
call pteststring2(?) ;
--call pteststring2(null);


--  integer ����
CREATE  Procedure  ptestint1(i in out int) as language java name 'SpTest5.ptestint1(int) ';

select 10 into x from db_root;
call ptestint1(x);
call ptestint1(10);
call ptestint1(null);
$integer,$10;
call ptestint1(?) ;


CREATE  Procedure  ptestint10(i in out int) as language java name 'SpTest5.ptestint1(int) ';

select 10 into x from db_root;
call ptestint10(x);
call ptestint10(10);
call ptestint10(null);
$integer,$10;
call ptestint10(?) ;

CREATE  Procedure  ptestint100(i int) as language java name 'SpTest5.ptestint1(int) ';

select 10 into x from db_root;
call ptestint100(x);
call ptestint100(10);
call ptestint100(null);
$integer,$10;
call ptestint100(?) ;

CREATE  Procedure  ptestint1000(i in int) as language java name 'SpTest5.ptestint1(int) ';

select 10 into x from db_root;
call ptestint1000(x);
call ptestint1000(10);
call ptestint1000(null);
$integer,$10;
call ptestint1000(?) ;

CREATE  Procedure  ptestint10000(i out int) as language java name 'SpTest5.ptestint1(int) ';

select 10 into x from db_root;
call ptestint10000(x);
call ptestint10000(10);
call ptestint10000(null);
$integer,$10;
call ptestint10000(?) ;

CREATE  Procedure  ptestint2(i in out int) as language java name 'SpTest5.ptestint2(int[]) ';

select 10 into x from db_root;
call ptestint2(x);
call ptestint2(10);
call ptestint2(null);
$integer,$10;
call ptestint2(?) ;


CREATE  Procedure  ptestint20(i in out int) as language java name 'SpTest5.ptestint2(int[]) ';

select 10 into x from db_root;
call ptestint20(x);
call ptestint20(10);
call ptestint20(null);
$integer,$10;
call ptestint20(?) ;

CREATE  Procedure  ptestint200(i int) as language java name 'SpTest5.ptestint2(int[]) ';

select 10 into x from db_root;
call ptestint200(x);
call ptestint200(10);
call ptestint200(null);
$integer,$10;
call ptestint200(?) ;

CREATE  Procedure  ptestint2000(i in int) as language java name 'SpTest5.ptestint2(int[]) ';

select 10 into x from db_root;
call ptestint2000(x);
call ptestint2000(10);
call ptestint2000(null);
$integer,$10;
call ptestint2000(?) ;

CREATE  Procedure  ptestint20000(i out int) as language java name 'SpTest5.ptestint2(int[]) ';

select 10 into x from db_root;
call ptestint20000(x);
call ptestint20000(10);
call ptestint20000(null);
$integer,$10;
call ptestint20000(?) ;



------------------------------------------------ Ÿ���� �ٸ� ���
drop procedure ptestint9;
CREATE  Procedure  ptestint9(i in out string) as language java name 'SpTest5.ptestint1(int) ';

select '10' into x from db_root;
call ptestint9(x);
call ptestint9('10');
call ptestint9(null);
$varchar,$10;
call ptestint9(?) ;

--  string ����

CREATE  Procedure  pteststring1(i in out string) as language java name 'SpTest5.pteststring1(java.lang.String) ';

select '10'into x from db_root;
call pteststring1(x);
call pteststring1('10');
call pteststring1(null);
$varchar,$10;
call pteststring1(?) ;


CREATE  Procedure  pteststring10(i in out string) as language java name 'SpTest5.pteststring1(java.lang.String) ';

select '10'into x from db_root;
call pteststring10(x);
call pteststring10('10');
call pteststring10(null);
$varchar,$10;
call pteststring10(?) ;

CREATE  Procedure  pteststring100(i string) as language java name 'SpTest5.pteststring1(java.lang.String) ';

select '10'into x from db_root;
call pteststring100(x);
call pteststring100('10');
call pteststring100(null);
$varchar,$10;
call pteststring100(?) ;

CREATE  Procedure  pteststring1000(i in string) as language java name 'SpTest5.pteststring1(java.lang.String) ';

select '10'into x from db_root;
call pteststring1000(x);
call pteststring1000('10');
call pteststring1000(null);
$varchar,$10;
call pteststring1000(?) ;

CREATE  Procedure  pteststring10000(i out string) as language java name 'SpTest5.pteststring1(java.lang.String) ';

select '10'into x from db_root;
call pteststring10000(x);
call pteststring10000('10');
call pteststring10000(null);
$varchar,$10;
call pteststring10000(?) ;

drop procedure pteststring2;
CREATE  Procedure  pteststring2(i in out string) as language java name 'SpTest5.pteststring2(java.lang.String[]) ';

select '10'into x from db_root;
call pteststring2(x);
call pteststring2('10');
call pteststring2(null);
$varchar,$10;
call pteststring2(?) ;


CREATE  Procedure  pteststring20(i in string) as language java name 'SpTest5.pteststring2(java.lang.String[]) ';

select '10'into x from db_root;
call pteststring20(x);
call pteststring20('10');
call pteststring20(null);
$varchar,$10;
call pteststring20(?) ;

CREATE  Procedure  pteststring200(i out string) as language java name 'SpTest5.pteststring2(java.lang.String[]) ';

select '10'into x from db_root;
call pteststring200(x);
call pteststring200('10');
call pteststring200(null);
$varchar,$10;
call pteststring200(?) ;

CREATE  Procedure  pteststring2000(i  string) as language java name 'SpTest5.pteststring2(java.lang.String[]) ';

select '10'into x from db_root;
call pteststring2000(x);
call pteststring2000('10');
call pteststring2000(null);
$varchar,$10;
call pteststring2000(?) ;



rollback;

autocommit on;

