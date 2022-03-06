# current stable version 1.4.3 of trac doesn't support python3
# so we can't use ubuntu 20.04; we'll revert to 18.04 instead
# version 1.5 of trac will support python3
# FROM ubuntu:20.04
ARG BUILD_FROM=ubuntu:18.04
FROM ubuntu:18.04
# environment variables
ENV DEBIAN_FRONTEND="noninteractive"
# set shell (otherwise HA will use ash)
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# set up base system
ARG BUILD_ARCH=amd64
# update index
RUN apt-get update
#
# add requirements and tools first before installing trac
#
# add database support
RUN apt-get install -y sqlite3
#
# make editing configuration files a bit easier
RUN apt-get install -y nano
#
# add some more requirements
RUN apt-get install -y pwgen
RUN apt-get install -y unzip zip
RUN apt-get install -y python-ldap
RUN apt-get install -y tzdata
RUN apt-get install -y graphviz
RUN apt-get install -y rsync
RUN apt-get install -y inotify-tools
#
# trac is not included in ubuntu 20.04; install using pip instead
#
# get pip first
# RUN apt install -y python3-pip
RUN apt install -y python-pip
# add some more requirements
RUN pip install wheel
RUN pip install pygments
RUN pip install docutils
RUN pip install textile==3.0.4
RUN pip install TracLDAPAuth
RUN pip install pyrad
RUN pip install genshi
#
# install trac (and all its dependencies)
RUN pip install trac==1.4.3
#
# install plugins
#
# add script to install plugins from source
ADD install_trac_zip /install_trac_zip
#
# install child tickets plugin from source
ADD childticketsplugin-18431.zip /childticketsplugin-18431.zip
RUN /install_trac_zip /childticketsplugin-18431.zip
# install master tickets plugin from source
ADD masterticketsplugin-18431.zip /masterticketsplugin-18431.zip
RUN /install_trac_zip /masterticketsplugin-18431.zip
# install announcer plugin from source
ADD AnnouncerPlugin-trunk-18431.zip /AnnouncerPlugin-trunk-18431.zip
RUN /install_trac_zip /AnnouncerPlugin-trunk-18431.zip
# install forms plugin from source
ADD tracforms-trunk-18431.zip /tracforms-trunk-18431.zip
RUN /install_trac_zip /tracforms-trunk-18431.zip
# install account manager plugin from source
ADD TracAccountManager-trunk-18431.zip /TracAccountManager-trunk-18431.zip
RUN /install_trac_zip /TracAccountManager-trunk-18431.zip
#
# todo:do we need these ?
###RUN apt-get install -y trac-customfieldadmin
###RUN apt-get install -y trac-wikiprint
###RUN apt-get install -y trac-wysiwyg
###RUN apt-get install -y trac-tags
###RUN apt-get install -y trac-diavisview
###RUN apt-get install -y python-flup
#
ADD setup_trac_config.sh /.setup_trac_config.sh
ADD setup_trac.sh /.setup_trac.sh
ADD run.sh /run.sh
ADD trac_logo.png /var/www/trac_logo.png
ADD crsync /crsync
#
ADD set_trac_user_password.py /usr/local/bin/
RUN chmod 755 /usr/local/bin/set_trac_user_password.py
#
# set our timezone
RUN ln -fs /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata
#
# here we keep trac
RUN mkdir /trac
#
# here we keep our backups
# not needed; provided as a data volume by HA
# RUN mkdir /backup
#
# here we restore from
RUN mkdir /restore
#
EXPOSE 80
CMD ["/run.sh"]
