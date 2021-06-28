#!/bin/bash

[ -f /.setup_trac.sh ] && /bin/bash /.setup_trac.sh

ROOT=/trac
TRACS="development maintenance administration sandbox"

# upgrade database and wiki
for TRAC in $TRACS; do trac-admin $ROOT/$TRAC upgrade; done
for TRAC in $TRACS; do trac-admin $ROOT/$TRAC wiki upgrade; done

tracd -p 80 -e /trac
