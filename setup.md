# 5G Network Setup

This setup guide is based off of installation guides at [srsRAN](https://docs.srsran.com/projects/project/en/latest/user_manuals/source/installation.html) and [Open5GS](https://open5gs.org/open5gs/docs/guide/01-quickstart/). This setup uses Ubuntu 22.04. This is a Split 8 deployment. The SDR used as the RU is a USRP B200 mini. Warning against the USRP E310. The E310 gave me way too many driver issues. Switching to the B200 mini caused the gNB to immediately work without any other changes.  

## srsRAN gNB Installation

Install required build tools and dependencies:  

```
sudo apt-get install cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev
```

For use with USRP, install USRP Hardware Driver ([UHD](https://files.ettus.com/manual/page_install.html)):

```
sudo apt-get install libuhd-dev uhd-host
```

Navigate to working directory:
```
WORK_DIR=<WORKING_DIRECTORY>
cd $WORK_DIR
```

Clone the srsRAN Project repository from GitHub:
```
git clone https://github.com/srsRAN/srsRAN_Project.git
```

Build the code-base:
```
cd srsRAN_Project
mkdir build
cd build
cmake ../
make -j $(nproc)
make test -j $(nproc)
```

One thing to note: `make test -j $(nproc)` might fail due to AT not having IPv6 on the network.  

## Open5GS Core Installation

Return to working directory:
```
cd $WORK_DIR
```

Get MongoDB:
```
sudo apt update
sudo apt install gnupg
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
```

```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

Install MongoDB packages:
```
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
```

Install Open5GS:
```
sudo add-apt-repository ppa:open5gs/latest
sudo apt update
sudo apt install open5gs
```

Clone the Open5GS repo from GitHub:
```
git clone https://github.com/open5gs/open5gs
```

One thing to note: the repo needs to be cloned from GitHub only if you are using open5gs-dbctl to register subscriber information. Open5GS does offer a WebUI to register subscriber info, but AT network makes it difficult to install. I found it's better to just use open5gs-dbctl, which is a command line interface for doing the same thing.  

## Configure/Run srsRAN gNB 

Find UHD Image Downloader:
```
sudo find / -name "uhd_images_downloader.py"
```

Run UHD Image Downloader:
```
sudo <uhd_images_downloader_PATH>
```

Place the gnb.yaml file found in this repo into the srsRAN configs folder at `$WORK_DIR/srsRAN_Project/configs`.  


To run the gNB:
```
cd $WORK_DIR/srsRAN_Project
sudo build/apps/gnb/gnb -c configs/gnb.yaml
```


## Configure/Run Open5GS Core

Register subscriber information:
```
cd $WORK_DIR/open5gs/misc/db
./open5gs-dbctl add <IMSI> <KEY> <OPC>
```

Configuration files for core NFs are located in `/etc/open5gs`. Configure the AMF, AUSF, NRF, SMF, UDM, and UPF to match the files in this repo.


To start/restart each component of the core:  
```
sudo systemctl restart open5gs-mmed
sudo systemctl restart open5gs-smfd
sudo systemctl restart open5gs-amfd
sudo systemctl restart open5gs-sgwcd
sudo systemctl restart open5gs-sgwud
sudo systemctl restart open5gs-upfd
sudo systemctl restart open5gs-hssd
sudo systemctl restart open5gs-pcrfd
sudo systemctl restart open5gs-nrfd
sudo systemctl restart open5gs-scpd
sudo systemctl restart open5gs-seppd
sudo systemctl restart open5gs-ausfd
sudo systemctl restart open5gs-udmd
sudo systemctl restart open5gs-pcfd
sudo systemctl restart open5gs-nssfd
sudo systemctl restart open5gs-bsfd
sudo systemctl restart open5gs-udrd
sudo systemctl restart open5gs-webui
```

Alternatively, download start5gs.sh into your working directory and run it using:
```
cd $WORK_DIR
./start5gs.sh
```

Note: anytime you make a change to any of the config files for your core, you need to restart that component. You can just run the restart command for that specific NF, or you can just run `./start5gs.sh` and restart the whole core.

To stop each component of the core:
```
sudo systemctl stop open5gs-mmed
sudo systemctl stop open5gs-sgwcd
sudo systemctl stop open5gs-smfd
sudo systemctl stop open5gs-amfd
sudo systemctl stop open5gs-sgwud
sudo systemctl stop open5gs-upfd
sudo systemctl stop open5gs-hssd
sudo systemctl stop open5gs-pcrfd
sudo systemctl stop open5gs-nrfd
sudo systemctl stop open5gs-scpd
sudo systemctl stop open5gs-seppd
sudo systemctl stop open5gs-ausfd
sudo systemctl stop open5gs-udmd
sudo systemctl stop open5gs-pcfd
sudo systemctl stop open5gs-nssfd
sudo systemctl stop open5gs-bsfd
sudo systemctl stop open5gs-udrd
sudo systemctl stop open5gs-webui
```

Or, download stop5gs.sh into your working directory and run it using:
```
cd $WORK_DIR
./stop5gs.sh
```
