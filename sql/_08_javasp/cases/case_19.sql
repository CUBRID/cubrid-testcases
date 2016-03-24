--+ holdcas on;

CREATE FUNCTION test_string (s string) RETURN string AS LANGUAGE JAVA NAME 'SpTest.testString(java.lang.String) return java.lang.String';

$out:varchar,$NULL;
? =  call test_string('select') ;
$out:varchar,$NULL;
? =  call test_string('aaaaaa') ;
$out:varchar,$NULL;
? =  call test_string('aaa' || 'bbb') ;

$out:varchar,$NULL,$varchar,$xya;
? =  call test_string(?) ;

drop function test_string;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

CREATE FUNCTION test_string (s string) RETURN string AS LANGUAGE JAVA NAME 'SpTest.testString(java.lang.String) return java.lang.String';

$out:varchar,$NULL;
? =  call test_string('select') ;
$out:varchar,$NULL;
? =  call test_string('aaaaaa') ;
$out:varchar,$NULL;
? =  call test_string('aaa' || 'bbb') ;

$out:varchar,$NULL,$varchar,$xya;
? =  call test_string(?) ;

drop function test_string;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

commit;
--+ holdcas off;

