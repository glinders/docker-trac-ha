#!/bin/bash

[ -f /.setup_trac.sh ] && /bin/bash /.setup_trac.sh

tracd -p 80 -e /trac
