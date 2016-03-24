autocommit off;



 CREATE  FUNCTION test_seq(seq sequence(int)) RETURN int AS LANGUAGE JAVA NAME 'SpTest.testArray(int[]) return int';


$out:string,$NULL;
  ? = call test_seq({2,3,4,5,6}) ;

rollback;
autocommit on;

