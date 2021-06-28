#!/bin/bash

source /.setup_trac_config.sh

setup_trac() {
    [ ! -d $1 ] && mkdir $1
    if [ ! -f $1/VERSION ]
    then
        trac-admin $1 initenv "$1" sqlite:db/trac.db
        setup_components $1
        setup_accountmanager $1
        setup_admin_user $1
        trac-admin $1 config set logging log_type stderr
        [ -f /var/www/trac_logo.png ] && cp -v /var/www/trac_logo.png $1/htdocs/your_project_logo.png
    fi
}

clean_house() {
    if [ -d /.setup_trac.sh ] && [ -d /.setup_trac_config.sh ]
    then
        rm -v /.setup_trac.sh
        rm -v /.setup_trac_config.sh
    fi
}

ROOT=/trac
TRACS="development maintenance administration sandbox"

for TRAC in $TRACS; do setup_trac $ROOT/$TRAC; done
clean_house
