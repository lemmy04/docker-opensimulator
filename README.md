# docker-opensimulator

Docker container for [OpenSimulator 0.9.1][3] running one or more regions connected to [OSGrid][8].

"OpenSimulator is an open source multi-platform, multi-user 3D application server. It can be used to create a virtual environment (or world) which can be accessed through a variety of clients, on multiple protocols. It also has an optional facility (the Hypergrid) to allow users to visit other OpenSimulator installations across the web from their 'home' OpenSimulator installation. In this way, it is the basis of a nascent distributed Metaverse."

## Install dependencies

  - [Docker][2]

To install docker in Ubuntu 18.04 use the commands:

    $ sudo apt-get update
    $ sudo wget -qO- https://get.docker.com/ | sh

 To install docker in other operating systems check [docker online documentation][4]

## Usage

This container image is setup for connectiong to [OSGrid][8], and running up to 4 regions on the ports 9000-9003.
If you already have a Regions.ini file, map it into the container as /home/opensim/opensim/bin/Regions/Regions.ini using -v
If you don't, run the "first configuration" step described in the next section.

If you want your region data to persist across container recreations or
updates, mount a volume or a folder into /home/opensim/opensim/bin/persistence

To run container use the command below:

    $ docker run -ti -d \
                 -p 9000:9000 -p 9000:9000/udp \
                 -p 9001:9001 -p 9001:9001/udp \
                 -p 9002:9002 -p 9002:9002/udp \
                 -p 9003:9003 -p 9003:9003/udp \
                 { -v your.region.ini:/home/opensim/opensim/bin/Regions/Regions.ini} \
		 { -v osgrid_data:/home/opensim/opensim/bin/persistence } \
                 lemmy04/opensim-osgrid:latest

 
## For the first configuration :

     $ docker exec -it container_id /bin/bash --login
     $ screen -r

Them respond the questions relate to virtual word : 

 - New region name []:     ==> need to entry region name that you want for it .(need to remember it).

 - RegionUUID [29923331-dddd-4acc-a3d8-46d3c129b6e3]:     ==> press enter key to keep the same.

 - Region Location [1000,1000]:                           ==> press enter key to keep the same.

 - Internal IP address [0.0.0.0]:                         ==> press enter key to keep the same.

 - Internal port [9000]:                                  ==> press enter key to keep the same.

 - Resolve hostname to IP on start (for running inside docker) [False]:  ==> press enter key to keep the same.

 - External host name [SYSTEMIP]:   ==> need to entry the external ip or your http address don't include the port.

 - New estate name [My Estate]:     ==> press enter or change it. 

 - Estate owner first name [Test]:  ==> change or enter for default Test (need to remember it).

 - Estate owner last name [User]:   ==> change or enter for default User (need to remember it).

 - Password:                       ==> remember it for login (need to remember it).

 - Email:                          ==> ..... 

 - User ID [6edd775a-8c1e-4a43-ad16-36df2af3ea0c]:  ==> press enter key to keep the same.

After some process it will show:

Region (.....) # 

 - 'quit' command to continue.

The container will shut down now, and has to be restarted.

## Use viewer to check the virtual world create by OpenSimulator:

Imprudence viewer [http://wiki.kokuaviewer.org/wiki/Imprudence:Downloads][6]

Grid Manager  to add your virtual world to the application ...

Where:

 - grid name ==> it will be region name

 - login URL ==>  http://external_ip:9000/  

 - login page ==> http://external_ip:9000/?method=login

Everything else no important at this moment. Press apply and then use info to log in.

## More Info

About OpenSimulator [www.opensimulator.org][1]

To help improve this container [lemmy04/docker-opensimulator-osgrid][5]

[1]:http://www.opensimulator.org/
[2]:https://www.docker.com
[3]:http://opensimulator.org/wiki/Download
[4]:http://docs.docker.com
[5]:https://github.com/lemmy04/docker-opensimulator-osgrid
[6]:http://wiki.kokuaviewer.org/wiki/Imprudence:Downloads
[8]:https://www.osgrid.org/