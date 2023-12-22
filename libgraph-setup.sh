#!/bin/bash

echo "WELCOME TO LIBGRAPH SETUP SCRIPT"

cd ~

echo "CHECKING FOR SYSTEM UPDATES..."
sudo apt update && sudo apt upgrade

echo "INSTALLING BUILD TOOLS..."
sudo apt install build-essential gcc

echo "DOWNLOADING LIBGRAPH FILE..."
wget "http://download.savannah.gnu.org/releases/libgraph/libgraph-1.0.2.tar.gz"
tar -xf libgraph-1.0.2.tar.gz
cd libgraph-1.0.2

echo "ADDING UNIVERSE REPOSITORY..."
sudo add-apt-repository universe
sudo apt update

echo "ADDING XENIAL REPOSITORY TO APT SOURCES..."
echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial main universe" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main universe" | sudo tee -a /etc/apt/sources.list

echo "Updating..."
sudo apt update

echo "INSTALLING DEPENDENCIES..."
sudo apt-get install libsdl-image1.2 libsdl-image1.2-dev guile-2.0 \
guile-2.0-dev libsdl1.2debian libart-2.0-dev libaudiofile-dev \
libesd0-dev libdirectfb-dev libdirectfb-extra libfreetype6-dev \
libxext-dev x11proto-xext-dev libfreetype6 libaa1 libaa1-dev \
libslang2-dev libasound2 libasound2-dev 


echo "CONFIGURING SYSTEM"
CPPFLAGS="$CPPFLAGS $(pkg-config --cflags-only-I guile-2.0)" \
  CFLAGS="$CFLAGS $(pkg-config --cflags-only-other guile-2.0)" \
  LDFLAGS="$LDFLAGS $(pkg-config --libs guile-2.0)" \
  ./configure

echo "MAKING BINARY..."
make

echo "INSTALLING BINARY..."
sudo make install

echo "COPYING SYMLINK..."
sudo cp /usr/local/lib/libgraph.* /usr/lib

echo "CREATING DEMO FILE..."
cat << EOF >> demo.cpp
#include <graphics.h>
int main()
{
   int gd = DETECT,gm,left=100,top=100,right=200,bottom=200,x= 300,y=150,radius=50;
   initgraph(&gd,&gm,NULL);
   rectangle(left, top, right, bottom);
   circle(x, y, radius);
   bar(left + 300, top, right + 300, bottom);
   line(left - 10, top + 150, left + 410, top + 150);
   ellipse(x, y + 200, 0, 360, 100, 50);
   outtextxy(left + 100, top + 325, "C Graphics Program");

   delay(5000);
   closegraph();
   return 0;
}
EOF

echo "COMPILING DEMO FILE..."
g++ demo.cpp -lgraph
echo "RUNNING DEMO FILE..."
./a.out

echo "THANK YOU FOR USING THIS SCRIPT"