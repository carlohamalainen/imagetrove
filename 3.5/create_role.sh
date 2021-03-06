#!/bin/bash

USER=admin
PASS=admin_CHANGEME

setuidgid postgres psql -q <<-EOF
    DROP ROLE IF EXISTS $USER;
    CREATE ROLE $USER WITH ENCRYPTED PASSWORD '$PASS';
    ALTER USER $USER WITH ENCRYPTED PASSWORD '$PASS';
    ALTER ROLE $USER WITH SUPERUSER;
    ALTER ROLE $USER WITH LOGIN;
