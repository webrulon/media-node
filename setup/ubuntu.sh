#!/bin/bash

# Supported Ubuntu Distro:
#	1. Ubuntu 8.04  Desktop/Server
#	2. Ubuntu 10.04 Desktop/Server
#	3. Ubuntu 10.10 Desktop/Server
#	4. Ubuntu 11.04 Desktop/Server
#	5. Ubuntu 11.10 Desktop/Server
#	6. Ubuntu 12.04 Desktop/Server

# Check The Target System Is Desktop/Server
dpkg --list | grep ubuntu-desktop &> /dev/null
DesktopDetect=$(echo $?)

# Check The Target System Version
cat /etc/lsb-release | grep 8.04  &> /dev/null
Ubuntu804=$(echo $?)
cat /etc/lsb-release | grep 10.04 &> /dev/null
Ubuntu1004=$(echo $?)
cat /etc/lsb-release | grep 10.10 &> /dev/null
Ubuntu1010=$(echo $?)
cat /etc/lsb-release | grep 11.04 &> /dev/null
Ubuntu1104=$(echo $?)
cat /etc/lsb-release | grep 11.10 &> /dev/null
Ubuntu1110=$(echo $?)
cat /etc/lsb-release | grep 12.04 &> /dev/null
Ubuntu1204=$(echo $?)

if [ $Ubuntu804 -eq 0 ]
then
	Version=Ubuntu804
elif [ $Ubuntu1004 -eq 0 ]
then
	Version=Ubuntu1004
elif [ $Ubuntu1010 -eq 0 ]
then
	Version=Ubuntu1010
elif [ $Ubuntu1104 -eq 0 ]
then
	Version=Ubuntu1104
elif [ $Ubuntu1110 -eq 0 ]
then
	Version=Ubuntu1110
elif [ $Ubuntu1204 -eq 0 ]
then
	Version=Ubuntu1204
fi

# Tell Users About Detetcted Desktop & Version
clear
if [ $DesktopDetect -eq 0 ]
then
	echo -e "\033[34m $Version Desktop Detected... \e[0m"
else
	echo -e "\033[34m $Version Server Detected... \e[0m"
fi


# Remove Any Existing Packages
clear
if [ $Version = Ubuntu804 ] || [ $Version = Ubuntu1004 ]
then
	echo -e "\033[34m Removing Unwanted Softwares From $Version... \e[0m"
	sudo apt-get -y remove ffmpeg x264 libx264-dev yasm liblame-dev
elif [ $Version = Ubuntu1010 ] || [ $Version = Ubuntu1104 ] || [ $Version = Ubuntu1110 ] || [ $Version = Ubuntu1204 ]
then
	echo -e "\033[34m Removing Unwanted Softwares From $Version... \e[0m"
	sudo apt-get -y remove ffmpeg x264 libav-tools libvpx-dev libx264-dev
fi


# Update The Dependencies
clear
echo -e "\033[34m Updating Dependencies... \e[0m"
sudo apt-get update


#Install The Packages
clear
if [ $Version = Ubuntu804 ]
then
	if [ $DesktopDetect -eq 0 ]
	then
		# Ubuntu8.04 Desktop
		echo -e "\033[34m  Installing Packages For $Version Desktop \e[0m"
		sudo apt-get -y install build-essential git-core checkinstall texi2html libfaac-dev \
		libsdl1.2-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev pkg-config zlib1g-dev \
		nasm libogg-dev
	else
		# Ubuntu8.04 Server
		echo -e "\033[34m  Installing Packages For $Version Server \e[0m"
		sudo apt-get -y install build-essential git-core checkinstall texi2html libfaac-dev \
		libvorbis-dev pkg-config zlib1g-dev nasm libogg-dev libsdl1.2-dev
	fi
elif [ $Version = Ubuntu1004 ]
then
	if [ $DesktopDetect -eq 0 ]
	then
		# Ubuntu10.04 Desktop
		echo -e "\033[34m  Installing Packages For $Version Desktop \e[0m"
		sudo apt-get install -y build-essential git-core checkinstall texi2html libfaac-dev \
		libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev \
		libvorbis-dev libx11-dev libxfixes-dev pkg-config zlib1g-dev nasm
	else
		# Ubuntu10.04  Server
		echo -e "\033[34m  Installing Packages For $Version Server \e[0m"
		sudo apt-get install -y build-essential git-core checkinstall texi2html libfaac-dev \
		libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev pkg-config zlib1g-dev nasm libsdl1.2-dev
	fi
elif [ $Version = Ubuntu1010 ] || [ $Version = Ubuntu1104 ] || [ $Version = Ubuntu1110 ] || [ $Version = Ubuntu1204 ]
then
	if [ $DesktopDetect -eq 0 ]
	then

		# Ubuntu10.10 11.04 11.10 12.04  Desktop
		echo -e "\033[34m  Installing Packages For $Version Desktop \e[0m"
		sudo apt-get -y install autoconf build-essential checkinstall git libfaac-dev libgpac-dev \
		libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev \
		librtmp-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev \
		libx11-dev libxfixes-dev pkg-config texi2html yasm zlib1g-dev
	else

		# Ubuntu10.10 11.04 11.10 12.04 Servers
		echo -e "\033[34m  Installing Packages For $Version Desktop \e[0m"
		sudo apt-get -y install autoconf build-essential checkinstall git libfaac-dev libgpac-dev \
		libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev libtheora-dev \
		libtool libvorbis-dev pkg-config texi2html yasm zlib1g-dev libsdl1.2-dev
	fi
fi


# Making Directory For Cloning Encoders
clear
MNDIR=$HOME/media-node
mkdir $MNDIR
echo -e "\033[34m Directory: $MNDIR Created \e[0m"


# Install Yasm Assembler
# Yasm Is Recommended For x264 & FFmpeg In Ubuntu8.04/ 10.04
if [ $Version = Ubuntu804 ] || [ $Version = Ubuntu1004 ]
then
	clear
	cd $MNDIR
	echo -e "\033[34m Downloading/Installing Yasm... \e[0m"
	wget -c http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
	tar zxvf yasm-1.2.0.tar.gz
	cd yasm-1.2.0
	./configure
	make
	sudo checkinstall --pkgname=yasm --pkgversion="1.2.0" --backup=no --deldoc=yes --default
fi


# Install H.264 (x264) Video Encoder
clear
cd $MNDIR
echo -e "\033[34m Cloning x264 Repo... \e[0m"
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --enable-static
make
if [ $Version = Ubuntu804 ]
then
	# Ubuntu 8.04
	echo -e "\033[34m Configure x264 For $Version \e[0m"
	sudo checkinstall --pkgname=x264 --pkgversion="2:0.svn$(date +%Y%m%d)-0.0ubuntu1" \
	--backup=no --deldoc=yes --default
elif [ $Version = Ubuntu1004 ]
then
	#Ubuntu 10.04
	echo -e "\033[34m Configure x264 For $Version \e[0m"
	sudo checkinstall --pkgname=x264 --default --pkgversion="3:$(./version.sh | \
	awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes
elif [ $Version = Ubuntu1010 ] || [ $Version = Ubuntu1104 ] || [ $Version = Ubuntu1110 ] || [ $Version = Ubuntu1204 ]
then
	# Ubuntu 10.10 11.04 11.10 12.04 
	echo -e "\033[34m Configure x264 For $Version \e[0m"
	sudo checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
	awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
	--fstrans=no --default
fi


# Install LAME MP3 Audio Encoder
# LAME Is Recommended For Ubuntu8.04/ 10.04
if [ $Version = Ubuntu804 ] || [ $Version = Ubuntu1004 ]
then
	clear
	cd $MNDIR
	echo -e "\033[34m  Downloading LAME... \e[0m"
	# Added liblame-dev & nasm To Above Common Remove/Install Block
	# sudo apt-get -y remove liblame-dev
	# sudo apt-get -y install nasm
	wget -c http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
	tar zxvf lame-3.99.5.tar.gz
	cd lame-3.99.5
	./configure --enable-nasm --disable-shared
	make
	sudo checkinstall --pkgname=lame-ffmpeg --pkgversion="3.99.5" --backup=no \
	--deldoc=yes --fstrans=no --default
fi


# Install libtheora Video Encoder
# Libtheora Is Recommended For Ubuntu8.04
if [ $Version = Ubuntu804 ]
then
	clear
	cd $MNDIR
	echo -e "\033[34m  Downloading Libtheora... \e[0m"
	# Added libogg-dev To Above Common Install Block
	# sudo apt-get -y install libogg-dev
	wget -c http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
	tar zxvf libtheora-1.1.1.tar.gz
	cd libtheora-1.1.1
	./configure --disable-shared
	make
	sudo checkinstall --pkgname=libtheora --pkgversion="1.1.1" --backup=no \
	--deldoc=yes --fstrans=no --default
fi


# Install AAC (fdk-aac) Audio Encoder
# AAC Is Recommended For Ubuntu 10.10/11.04/11.10/12.04
if [ $Version = Ubuntu1010 ] || [ $Version = Ubuntu1104 ] || [ $Version = Ubuntu1110 ] || [ $Version = Ubuntu1204 ]
then
	clear
	cd $MNDIR
	echo -e "\033[34m  Cloning FDK-AAC Repo... \e[0m"
	git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
	cd fdk-aac
	autoreconf -fiv
	./configure --disable-shared
	make
	sudo checkinstall --pkgname=fdk-aac --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
	--deldoc=yes --fstrans=no --default
fi


# Install VP8 (libvpx) Video Encoder/Decoder
clear
cd $MNDIR
echo -e "\033[34m  Cloning VP8 Repo... \e[0m"
git clone --depth 1 http://git.chromium.org/webm/libvpx.git
cd libvpx
./configure
make
sudo checkinstall --pkgname=libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no \
	--deldoc=yes --fstrans=no --default


# Install FFmpeg
clear
cd $MNDIR
echo -e "\033[34m  Cloning FFmpeg Repo... \e[0m"
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg

if [ $Version = Ubuntu804 ]
then
	if [ $DesktopDetect -eq 0 ]
	then
		#Ubuntu8.04 Desktop
		./configure --enable-gpl --enable-version3 --enable-nonfree --enable-libfaac \
		--enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libvpx \
		--enable-libx264 --enable-x11grab
	else
		#Ubuntu8.04 Server
		./configure --enable-gpl --enable-version3 --enable-nonfree --enable-libfaac \
		--enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libvpx \
		--enable-libx264
	fi

	make
	sudo checkinstall --pkgname=ffmpeg --pkgversion="4:git-$(date +%Y%m%d)" --backup=no \
	--deldoc=yes --default

elif [ $Version = Ubuntu1004 ]
then
	if [ $DesktopDetect -eq 0 ]
	then
		#Ubuntu 10.04 Desktop
		./configure --enable-gpl --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb \
		--enable-libopencore-amrwb --enable-libtheora --enable-libvorbis --enable-libvpx \
		--enable-libx264 --enable-nonfree --enable-version3 --enable-x11grab
	else
		#Ubuntu10.04 Server
		./configure --enable-gpl --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb \
		--enable-libopencore-amrwb --enable-libtheora --enable-libvorbis --enable-libvpx \
		--enable-libx264 --enable-nonfree --enable-version3
	fi

	make
	sudo checkinstall --pkgname=ffmpeg --pkgversion="5:$(./version.sh)" --backup=no \
	--deldoc=yes --default

elif [ $Version = Ubuntu1010 ] || [ $Version = Ubuntu1104 ] || [ $Version = Ubuntu1110 ] || [ $Version = Ubuntu1204 ]
then
	if [ $DesktopDetect -eq 0 ]
	then
		# Ubuntu Desktop
		./configure --enable-gpl --enable-libfaac --enable-libfdk-aac --enable-libmp3lame \
		--enable-libopencore-amrnb --enable-libopencore-amrwb --enable-librtmp --enable-libtheora \
		--enable-libvorbis --enable-libvpx --enable-x11grab --enable-libx264 --enable-nonfree \
		--enable-version3
	else
		# Ubuntu Server
		./configure --enable-gpl --enable-libfaac --enable-libfdk-aac --enable-libmp3lame \
		--enable-libopencore-amrnb --enable-libopencore-amrwb --enable-librtmp --enable-libtheora \
		--enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree \
		--enable-version3
	fi

	make
	sudo checkinstall --pkgname=ffmpeg --pkgversion="5:$(date +%Y%m%d%H%M)-git" --backup=no \
	--deldoc=yes --fstrans=no --default
fi

# Adding Entry In Hash Table
clear
echo -e "\033[34m Updating Hash Table... \e[0m"
hash x264 ffmpeg ffplay ffprobe
