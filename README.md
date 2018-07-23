# trac as a Docker service

trac runs as a ervice, using a data container.

Data can be backed up and restored using the backup and restore containers

## usage

    make build; make run

## backup

All data resides in directory /trac.
Data is backed up to directory /backup (tar.gz file).
To back up, use ommand:

    docker run trac-app-backup

Use `docker cp trac-app:/backup <dest>` to get backups out of container.


## restore

Archive to restore must be one created above (format: 20180724.trac.tar.gz).
Use `docker cp <archive> trac-app:/restore` to get archive into container.
To restore, use command:

    docker run trac-app-restore
