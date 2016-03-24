autocommit off;
create class foo (attr1  int);
ALTER CLASS foo
    ADD METHOD
            get_generic Versionable
            function version_get_generic;
rollback;
