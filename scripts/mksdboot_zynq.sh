#!/bin/bash
#
# Prepare an SD card for booting the Xilinx ZYNQ ZC702.
#
# Based on a script written by Brijesh Singh, Texas Instruments Inc.
#
# Author: Joe MacDonald <joe_macdonald@mentor.com>
#
# (c) 2014 Mentor Graphics
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

echo "
Note: This script has been deprecated, please use the sd-card image in the
deploy folder to prepare sd-card. Refer to the quick start guide for details.
"

VERSION="1.0"

: ${kernel:="uImage"}
: ${rootfs:="console-image"}
: ${fsbl:="boot.bin"}
fsbl_standalone=0
unset copy

execute ()
{
    $* >/dev/null
    if [ $? -ne 0 ]; then
        echo
        echo "ERROR: executing $*"
        echo
        exit 1
    fi
}

version ()
{
  echo
  echo "`basename $1` version $VERSION"
  echo "Script to create bootable SD card for Xilinx ZYNQ ZC702"
  echo

  exit 0
}

usage ()
{
  echo "
Usage: `basename $1` --device=<sd-card-device> <options> [ files for boot partition ]

  --device                  SD block device node (e.g /dev/mmcblk0) [REQUIRED]
                            [ default: NONE ]

  -s|--sdk [sdk_dir]        Where is sdk installed?

  -r|--rootfs [rootfs]      Which rootfs would you like to install?
                            [ default: ${rootfs} ]

  -k|--kernel [kernel]      Which kernel would you like to install?
                            [ default: uImage ]

  -b|--devicetree [dtb]     Which device tree blob would you like to install?

  -m|--machine [machine]    What machine are you building?
                            Options: zc702-zynq7-mel zc702-zynq7-mel-remote zedboard-zynq7-mel zedboard-zynq7-mel-remote

  -f|--fsbl [image]         Which bootloader would you like to use?
                            Options: boot.bin mel-boot.bin
                            [ default: boot.bin ]
  -R|--remote [remote_fw]   Absolute or relative path to remote firmware booted by MEL in MEMF configuration
  -M|--master [master_fw]   Absolute or relative path to master firmware to boot MEL in MEMF configuration

  --version                 Print version.
  --help                    Print this help message.
"
  exit 1
}

check_if_main_drive ()
{
  mount | grep " on / type " > /dev/null
  if [ "$?" != "0" ]
  then
    echo "-- WARNING: not able to determine current filesystem device"
  else
    main_dev=`mount | grep " on / type " | awk '{print $1}'`
    echo "-- Main device is: $main_dev"
    echo $main_dev | grep "$device" > /dev/null
    [ "$?" = "0" ] && echo "++ ERROR: $device seems to be current main drive ++" && exit 1
  fi

}

# main
# Check if the script was started as root or with sudo
user=`id -u`
[ "$user" != "0" ] && echo "++ Must be root/sudo ++" && exit

# Process command line...
while [ $# -gt 0 ] ; do
  case $1 in
      -h|-\?|--help)
          usage $0
          ;;

      -v|--version)
          version $0
          ;;

      -d|--device)
          if  [ "$2" ]; then
              case $2 in
                  -* )
                      # another option appears to follow, not a parameter
                      echo "ERROR: device must not be empty" >&2
                      exit 1
                      ;;
                  *)
                      device=$2
                      shift 2
                      ;;
              esac
          else
              echo "ERROR: device must not be empty" >&2
              exit 1
          fi
          ;;
      --device=?*)
          device=${1#*=}
          shift
          ;;
      --device=)
          echo "ERROR: device must not be empty" >&2
          exit 1
          ;;

      -m|--machine)
          if  [ "$2" ]; then
              case $2 in
                  -* )
                      # another option appears to follow, not a parameter
                      echo "ERROR: machine must not be empty" >&2
                      exit 1
                      ;;
                  *)
                      MACHINE=$2
                      shift 2
                      ;;
              esac
          else
              echo "ERROR: machine must not be empty" >&2
              exit 1
          fi
          ;;
      --machine=?*)
          MACHINE=${1#*=}
          shift
          ;;
      --machine=)
          echo "ERROR: machine must not be empty" >&2
          exit 1
          ;;

      -f|--fsbl)
          if  [ "$2" ]; then
              case $2 in
                  -* )
                      # another option appears to follow, not a parameter
                      echo "ERROR: fsbl must not be empty" >&2
                      exit 1
                      ;;
                  boot.bin)
                      fsbl=$2
                      shift 2
                      ;;
                  mel-boot.bin)
                      fsbl=$2
                      fsbl_standalone=1
                      shift 2
                      ;;
                  *)
                      echo "ERROR: fsbl must be one of boot.bin or mel-boot.bin" >&2
                      exit 1
                      ;;
              esac
          else
              echo "ERROR: fsbl must not be empty" >&2
              exit 1
          fi
          ;;
      --fsbl=?*)
          fsbl=${1#*=}
          if [ "${fsbl}" != "mel-boot.bin" -a "${fsbl}" != "boot.bin" ] ; then
              echo "ERROR: fsbl must be one of boot.bin or mel-boot.bin" >&2
              exit 1
          else
              if [ "${fsbl}" = "mel-boot.bin" ]; then
                  fsbl_standalone=1
              fi
          fi
          shift
          ;;
      --fsbl=)
          echo "ERROR: fsbl must not be empty" >&2
          exit 1
          ;;

      -k|--kernel)
          if  [ "$2" ]; then
              case $2 in
                  -* )
                      # another option appears to follow, not a parameter
                      echo "ERROR: kernel must not be empty" >&2
                      exit 1
                      ;;
                  *)
                      kernel=$2
                      shift 2
                      ;;
              esac
          else
              echo "ERROR: kernel must not be empty" >&2
              exit 1
          fi
          ;;
      --kernel=?*)
          kernel=${1#*=}
          shift
          ;;
      --kernel=)
          echo "ERROR: kernel must not be empty" >&2
          exit 1
          ;;

      -b|--devicetree)
          if  [ "$2" ]; then
              case $2 in
                  -* )
                      # another option appears to follow, not a parameter
                      echo "ERROR: devicetree must not be empty" >&2
                      exit 1
                      ;;
                  *)
                      KERNEL_DEVICETREE=$2
                      shift 2
                      ;;
              esac
          else
              echo "ERROR: devicetree must not be empty" >&2
              exit 1
          fi
          ;;
      --devicetree=?*)
          KERNEL_DEVICETREE=${1#*=}
          shift
          ;;
      --devicetree=)
          echo "ERROR: devicetree must not be empty" >&2
          exit 1
          ;;

      -s|--sdk)
          if  [ "$2" ]; then
              case $2 in
                  -* )
                      # another option appears to follow, not a parameter
                      echo "ERROR: sdk must not be empty" >&2
                      exit 1
                      ;;
                  *)
                      sdkdir=$2
                      shift 2
                      ;;
              esac
          else
              echo "ERROR: sdk must not be empty" >&2
              exit 1
          fi
          ;;
      --sdk=?*)
          sdkdir=${1#*=}
          shift
          ;;
      --sdk=)
          echo "ERROR: sdk must not be empty" >&2
          exit 1
          ;;

      -r|--rootfs)
          if  [ "$2" ]; then
              case $2 in
                  -* )
                      # another option appears to follow, not a parameter
                      echo "ERROR: rootfs must not be empty" >&2
                      exit 1
                      ;;
                  *)
                      rootfs="$2"
                      shift 2
                      ;;
              esac
          else
              echo "ERROR: rootfs must not be empty" >&2
              exit 1
          fi
          ;;
      --rootfs=?*)
          rootfs=${1#*=}
          shift
          ;;
      --rootfs=)
          echo "ERROR: rootfs must not be empty" >&2
          exit 1
          ;;

      -R|--remote)
          if  [ "$2" ]; then
              case $2 in
                  -* )
                      # another option appears to follow, not a parameter
                      echo "ERROR: remote firmware must not be empty" >&2
                      exit 1
                      ;;
                  *)
                      remote=$2
                      shift 2
                      ;;
              esac
          else
              echo "ERROR: remote firmware must not be empty" >&2
              exit 1
          fi
          ;;
      --remote=?*)
          remote=${1#*=}
          shift
          ;;
      --remote=)
          echo "ERROR: remote firmware must not be empty" >&2
          exit 1
          ;;

      -M|--master)
          if  [ "$2" ]; then
              case $2 in
                  -* )
                      # another option appears to follow, not a parameter
                      echo "ERROR: master firmware must not be empty" >&2
                      exit 1
                      ;;
                  *)
                      master=$2
                      shift 2
                      ;;
              esac
          else
              echo "ERROR: master firmware must not be empty" >&2
              exit 1
          fi
          ;;
      --master=?*)
          master=${1#*=}
          shift
          ;;
      --master=)
          echo "ERROR: master firmware must not be empty" >&2
          exit 1
          ;;

      --)
          shift
          break
          ;;
      -?*)
          printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
          ;;

      *)
         copy="$copy $1"
         shift
         ;;
  esac
done

if [ -z "${MACHINE}" ]; then
    echo "ERROR: Please specify a valid machine"
    exit 1;
fi

if [ -n "${rootfs}" ] ; then
    ROOTFS_IMAGE="${rootfs}-${MACHINE}.tar.gz"
fi

if [ -z "${KERNEL_DEVICETREE}" ]; then
    KERNEL_DEVICETREE="${MACHINE}.dtb"
fi

if [ -z "${sdkdir}" ]; then
    sdkdir=`pwd`/tmp/deploy/images/${MACHINE}
fi

MKFS_VFAT=`which mkfs.vfat`
MKFS_EXT3=`which mkfs.ext3`
FDISK=`which fdisk`
MODULES=modules-${MACHINE}.tgz
# Ensure we have all the resources necessary before proceeding.

# Check our host dependencies
if [ -z "${FDISK}" ]; then
    echo "ERROR: Unable to find a working fdisk in \$PATH"
    exit 1;
fi

if [ -z "${MKFS_VFAT}" ]; then
    echo "ERROR: Unable to find a working mkfs.vfat in \$PATH"
    exit 1;
fi

if [ -z "${MKFS_EXT3}" ]; then
    echo "ERROR: Unable to find a working mkfs.ext3 in \$PATH"
    exit 1;
fi

# Check the target components
if [ -z "${sdkdir}" -o ! -d "${sdkdir}" ]; then
    echo "ERROR: Invalid SDK specified: [${sdkdir}]"
    exit 1;
fi

if [ -z "${device}" -o ! -b "${device}" ]; then
    echo "ERROR: Invalid device specified (is this a block device?): [${device}]"
    exit 1;
fi

if [ -z "${kernel}" -o ! -f "${sdkdir}/${kernel}" ]; then
    echo "ERROR: ${kernel} does not exist or is not a regular file:"
    echo "       [${sdkdir}/${kernel}]"
    exit 1;
fi

if [ -z "${KERNEL_DEVICETREE}" -o ! -f "${sdkdir}/${KERNEL_DEVICETREE}" ]; then
    echo "ERROR: ${KERNEL_DEVICETREE} does not exist or is not a regular file:"
    echo "       [${sdkdir}/${KERNEL_DEVICETREE}]"
    exit 1;
fi

if [ -n "${remote}" -a ! -f "${remote}" ]; then
    echo "ERROR: remote firmware ${remote} does not exist or is not a regular file"
    exit 1;
fi

if [ -n "${master}" -a ! -f "${master}" ]; then
    echo "ERROR: master firmware ${master} does not exist or is not a regular file"
    exit 1;
fi

# Pre-built image doesn't have machine name appended 
if [ ! -f $sdkdir/${ROOTFS_IMAGE} ]; then
    ROOTFS_IMAGE=`echo $ROOTFS_IMAGE | sed "s:-${MACHINE}::"`
fi

if [ ! -f $sdkdir/${MODULES} ]; then
    MODULES=`echo $MODULES | sed "s:-${MACHINE}::"`	
fi

if [ -z "${ROOTFS_IMAGE}" -o ! -f "${sdkdir}/${ROOTFS_IMAGE}" ]; then
    echo "ERROR: ${ROOTFS_IMAGE} does not exist or is not a regular file:"
    echo "       [${sdkdir}/${ROOTFS_IMAGE}]"
    exit 1;
fi

if [ ! -f $sdkdir/${MODULES} ]; then
    echo "ERROR: ${MODULES} does not exist or is not a regular file:"
    echo "       [${sdkdir}/${MODULES}]"
    exit 1;
fi

# Create a work directory for ourselves
zc702_scratch=$(mktemp -d)
if [ -z "${zc702_scratch}" -o ! -d "${zc702_scratch}" ] ; then
    echo "ERROR: Unable to create scratch directory: [${zc702_scratch}]"
    exit 1
fi

# Everything seems in order, set to work
echo "
************************************************************
*         THIS WILL DELETE ALL THE DATA ON ${device}
*
*         WARNING! Make sure your computer does not go
*                  in to idle mode while this script is
*                  running. The script will complete,
*                  but your SD card may be corrupted.
*
*         Summary:
*         device:       ${device}
*         bootloader:   ${fsbl}
*         kernel:       ${kernel}
*         dtb:          ${KERNEL_DEVICETREE}
*         rootfs:       ${ROOTFS_IMAGE}
*
*         Press <ENTER> to confirm, <CTRL>-C to abort...
************************************************************"
read junk

for i in $device*; do
   echo "unmounting device '$i'"
   umount $i 2>/dev/null
done

cat << END | fdisk ${device}
o
n
p
1

+256M
n
p
2


t
1
c
a
1
w
END

# handle various device names.
PARTITION1=${device}1
PARTITION2=${device}2
if [ ! -b ${PARTITION1} ]; then
        PARTITION1=${device}p1
        if [ ! -b ${PARTITION1} ]; then
            echo "ERROR: Unable to determine partitiion names for ${device}"
            exit 1
        else
            PARTITION2=${device}p2
        fi
fi

# Sometimes a fuse-based automounter will automatically mount the devices,
# ensure nothing is mounted before we try to make a new filesystem on the
# partitions.
for i in $device*; do
   echo "unmounting device '$i'"
   umount $i 2>/dev/null
done

# make partitions.
echo "Formating ${PARTITION1} (boot) ..."
if [ -b ${PARTITION1} ]; then
    ${MKFS_VFAT} -F 32 -n "boot" ${PARTITION1}
else
    echo "Cant find boot partition in /dev"
    exit 1
fi

echo "Formating ${PARTITION2} (rootfs) ..."
if [ -b ${PARITION2} ]; then
	${MKFS_EXT3} -L "rootfs" ${PARTITION2}
else
	echo "Cant find rootfs partition in /dev"
fi

echo "Copying filesystem on ${PARTITION1},${PARTITION2}"
execute "mkdir -p ${zc702_scratch}/boot"
execute "mkdir -p ${zc702_scratch}/rootfs"
execute "mount ${PARTITION1} ${zc702_scratch}/boot"
execute "mount ${PARTITION2} ${zc702_scratch}/rootfs"
# if MEL is acting as MEMF remote, boot partition would only contain master firmware
if [ -n "${master}" ] ; then 
    echo "Installing MEMF master firmware on filesystem"
    execute "cp -v ${master} ${zc702_scratch}/boot"
else
    execute "cp -v ${sdkdir}/${kernel} ${zc702_scratch}/boot/"
    execute "cp -v ${sdkdir}/${KERNEL_DEVICETREE} ${zc702_scratch}/boot/"
    for i in $copy ; do
        execute "cp -v $copy ${zc702_scratch}/boot/"
    done
fi

execute "cp -v ${sdkdir}/${fsbl} ${zc702_scratch}/boot/boot.bin"

if [ ${fsbl_standalone} -ne 1 ] ; then
        execute "cp -v ${sdkdir}/u-boot.img ${zc702_scratch}/boot/"
    fi

echo "Extracting filesystem [${ROOTFS_IMAGE}] on ${PARTITION2} ..."
execute "tar -zvxf ${sdkdir}/${ROOTFS_IMAGE} -C ${zc702_scratch}/rootfs"
execute "tar -zvxf ${sdkdir}/${MODULES} -C ${zc702_scratch}/rootfs"

if [ -n "${remote}" ] ; then
    echo "Installing MEMF remote firmware on filesystem"
    execute "install -vD ${remote} ${zc702_scratch}/rootfs/lib/firmware/firmware"
fi

for i in $device*; do
   echo "unmounting device '$i'"
   umount $i 2>/dev/null
done

execute "rm -rf ${zc702_scratch}"
echo "completed!"
