#Name of container: docker-opensimulator-osgrid
#Version of container: 0.9.1.066a6fb

FROM opensuse/tumbleweed:latest
MAINTAINER lemmy04 <Mathias.Homann@openSUSE.org>
LABEL version=0.9.2.dev.cfef190 Description="For running an opensim that hooks into osgrid instance in a docker container." Vendor="Mathias.Homann@openSUSE.org"

## install all updates
## Date: 2020-04-01
RUN zypper --gpg-auto-import-keys addrepo -r https://download.opensuse.org/repositories/Mono:/Factory/openSUSE_Factory/Mono:Factory.repo -e -f -p 50
RUN zypper --gpg-auto-import-keys ref
RUN zypper patch -y -l --with-optional ; exit 0

## do it again, could be an update for zypper in there
RUN zypper patch -y -l --with-optional ; exit 0

## install everything needed to run the bot
RUN zypper install -y -l --recommends mono-core mono-extras unzip curl screen sed less htop

## clean zypper cache for smaller image
RUN zypper cc --all

## setup /run/uscreens
RUN mkdir -p /run/uscreens
RUN chmod a+rwx,o+t /run/uscreens

## create an opensim user and group
RUN useradd \
        -c "The user that runs the opensim regions" \
        --no-log-init \
        -m \
        -U \
        opensim

##Adding opensim zip file
# Unpacking to /home/opensim/opensim
ADD ["http://danbanner.onikenkon.com/osgrid/osgrid-opensim-03152010.v0.9.2.cfef190.zip", "/tmp/opensim.zip"]
RUN unzip -d /home/opensim/opensim /tmp/opensim.zip

# create persistence
RUN mkdir -p /home/opensim/opensim/bin/persistence

# add opensim preconfigured ini files
ADD ["http://download.osgrid.org/OpenSim.ini.txt", "/home/opensim/opensim/bin/OpenSim.ini"]
ADD ["http://download.osgrid.org/GridCommon.ini.txt", "/home/opensim/opensim/bin/config-include/GridCommon.ini"]
ADD ["http://download.osgrid.org/FlotsamCache.ini.txt", "/home/opensim/opensim/bin/config-include/FlotsamCache.ini"]
ADD ["SQLiteStandalone.ini", "/home/opensim/opensim/bin/config-include/storage/SQLiteStandalone.ini"]

# rename osslEnable.ini.example
RUN mv /home/opensim/opensim/bin/config-include/osslEnable.ini.example /home/opensim/opensim/bin/config-include/osslEnable.ini

# add startup script
COPY opensim.sh /home/opensim/opensim/bin

# fix owner and perms
RUN chmod +x /home/opensim/opensim/bin/opensim.sh
RUN chown -R opensim:opensim /home/opensim/opensim

# To allow access from outside of the container  to the container service at these ports
# Need to allow ports access rule at firewall too .  
EXPOSE 9000-9003/tcp
EXPOSE 9000-9003/udp

WORKDIR /home/opensim/opensim/bin
USER opensim
CMD ["/home/opensim/opensim/bin/opensim.sh"]
