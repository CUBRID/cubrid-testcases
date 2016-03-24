/* $Revision: 1.2 $ */
#include <stdio.h>
#include <string.h>
void main (int argc, char **argv)
{
    EXEC SQL BEGIN DECLARE SECTION;
    int t_int_in=9;
    char *db_name = argv[1];
    EXEC SQL END DECLARE SECTION;
    EXEC SQL WHENEVER SQLERROR GOTO err;
    uci_startup(argv[0]);
    EXEC SQL CONNECT :db_name;

    /* Prepare the insert statement */
    EXEC SQL PREPARE stmt FROM 'select fname from faculty where ssn = ?';

    EXEC SQL EXECUTE stmt USING :t_int_in;

    printf("success\n");
    goto DONE;
   
  err:
    printf("%s %d  %s (sqlcode = %d) \n", SQLFILE, SQLLINE, SQLERRMC, SQLCODE);

  DONE:
    EXEC SQL WHENEVER SQLERROR CONTINUE;
    EXEC SQL ROLLBACK WORK;
    EXEC SQL DISCONNECT;
}
