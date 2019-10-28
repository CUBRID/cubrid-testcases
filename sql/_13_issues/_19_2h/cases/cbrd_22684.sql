--default value of no_backslash_escapes is yes
SELECT JSON_QUOTE('\taaa');  

SET SYSTEM PARAMETERS 'no_backslash_escapes=no';
SELECT JSON_QUOTE('\taaa');

--set back to the default value
SET SYSTEM PARAMETERS 'no_backslash_escapes=yes';
