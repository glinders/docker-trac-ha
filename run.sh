#!/bin/bash

[ -f /.setup_trac.sh ] && /bin/bash /.setup_trac.sh

ROOT=/trac
TRACS="development maintenance administration sandbox"

# upgrade database and wiki
for TRAC in $TRACS; do trac-admin $ROOT/$TRAC upgrade; done
for TRAC in $TRACS; do trac-admin $ROOT/$TRAC wiki upgrade; done

# start synchronisation to directory /data
/crsync &

# start tracd using https
tracd -p 80 -e /trac --protocol https --certfile /ssl/fullchain.pem --keyfile /ssl/privkey.pem 
