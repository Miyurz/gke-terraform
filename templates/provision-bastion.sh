#!/usr/bin/env bash

set -euoix pipefail

function checkIfDebianOrRPM {
  
  flavor=null

  if [ -f "/etc/debian_version" ];
  then
    #echo "INFO: Probably a debian version"
    flavor="debian"
  elif [ -f "/etc/redhat-release" ];
  then
    #echo "INFO: Probably a RPM based version"
    flavor="rpm"
  fi 
 
  echo $flavor
}

function checkIfPythonExists {

  which python > /dev/null && { version=$(python -c 'import sys; \
                                                  print(".".join(map(str, sys.version_info[:3])))');\
                                #echo "Python version is ${version}" \
                                echo ${version} 
                              } \
                           || {  #echo Python not installed; \
                                echo 0;
                              }
}


function installDebianPackages {
  #sudo apt-get update -y

  #1. Install python 3 if python is not installed or 2.x version is installed
  if  [[ "$(checkIfPythonExists)" == "0" || "$(checkIfPythonExists)" =~ "2."* ]];
  then
    #2. Install python3 and pip3
    echo "Upgrade all packages"
    sudo apt-get -y upgrade
    echo "Install python3"
    sudo apt-get install -y python3 
    echo "Install python3 pip"
    sudo apt-get install -y python3-pip
  else
    echo Python version installed is $(checkIfPythonExists)
  fi
  
  sudo pip install --upgrade pip  
  sudo pip install ansible
}

function installRPMPackages() {
  sudo yum clean all 
  sudo yum update -y
  
  #1. Install python 3 if not installed
  checkIfPythonExists

  # DO NOT DELETE THE OLD PYTHON2.6 that comes pre-bundled with RHEL/CentOS/Fedora. yum is written in Python and there will be many problems with repairing the system.

  #A collection of utilities and plugins that extend and supplement yum
  sudo yum -y install yum-utils
  #CentOS Development Tools, which are used to allow you to build and compile software from source code:
  sudo yum -y groupinstall development 

  #CentOS is derived from RHEL (Red Hat Enterprise Linux), which has stability as its primary focus. Because of this, tested and stable versions of applications are what is most commonly found on the system and in downloadable packages, so on CentOS you will only find Python 2.Since instead we would like to install the most current upstream stable release of Python 3, we will need to install IUS, which stands for Inline with Upstream Stable. A community project, IUS provides Red Hat Package Manager (RPM) packages for some newer versions of select software

  #To install IUS, let’s install it through yum:
  sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm || true
  
  #Once IUS is finished installing, we can install the most recent version of Python:
  sudo yum -y install python36u
 
  #We will next install pip, which will manage software packages for Python:
  sudo yum -y install python36u-pip

  #List installed pip packages
  /bin/pip3.6 list --format=columns

  #Install ansible via pip
  sudo /bin/pip3.6 install ansible
}

function main {

  #Determing the machine type
  platform="$(uname -s)"
  case "${platform}" in
      Linux*)     
        machine=Linux;
        #Check for debian/RPM like ubuntu,debian,mint,centos,redhat,opensuse
        distro=$(checkIfDebianOrRPM)
        echo distro = $distro    
        case "${distro}" in
          rpm)
            echo "Install via yum"
            installRPMPackages
          ;;
          debian)
            echo "Install via apt-get"
            installDebianPackages
          ;;
          *)
            echo "Unknown Linux distro :| "
            exit 1; 
          esac
        ;;
      Darwin*)    
        machine=Mac;;
      CYGWIN*)    
        machine=Cygwin;;
      MINGW*)     
        machine=MinGw;;
      *)          
        machine="UNKNOWN PLATFORM:${machine}"; exit 1;
  esac
  echo Provisioning machine ${machine}

}

main

