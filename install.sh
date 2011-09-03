#!/bin/sh

echo "Make sure your download and install the Platypus installer from here: http://www.sveinbjorn.org/platypus"

create_dirs() {
  if [ ! -d "build" ]
	then
		mkdir build
	fi

	if [ ! -d "resources" ]
	then
		mkdir resources
	fi
}

check_qt() {
	if [ ! -f "resources/qt-mac-opensource-4.7.3.dmg" ]
	then
		curl "http://get.qt.nokia.com/qt/source/qt-mac-opensource-4.7.3.dmg" > "resources/qt-mac-opensource-4.7.3.dmg"
	fi
}

check_git() {
	if [ ! -f "resources/git-1.7.6-i386-snow-leopard.dmg" ]
	then
		curl "http://git-osx-installer.googlecode.com/files/git-1.7.6-i386-snow-leopard.dmg" > "resources/git-1.7.6-i386-snow-leopard.dmg"
	fi
}

get_yaml() {
	if [ ! -f "build/yaml-0.1.4.tar.gz" ]
	then
		curl "http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz" > "build/yaml-0.1.4.tar.gz"
	fi
}

build_yaml() {
	cd build
	if [ ! -d "yaml" ]
	then
		mkdir yaml
	fi
	tar -xvzf yaml-0.1.4.tar.gz
	cd yaml-0.1.4
	CFLAGS="-arch i386 -arch x86_64"
	export CFLAGS
	LDFLAGS="-arch i386 -arch x86_64"
	export LDFLAGS
	./configure --prefix="$builddir/yaml" --disable-dependency-tracking
	make
	make install
	cd ../..
	tar cvzf resources/yaml-0.1.4.universal.tar.gz build/yaml
}

check_yaml() {
	if [ ! -f "resources/yaml-0.1.4.universal.tar.gz" ]
	then
		get_yaml
		build_yaml
	fi
}

get_ruby() {
	if [ ! -f "build/ruby-1.9.2-p290.tar.gz" ]
	then
		curl "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz" > "build/ruby-1.9.2-p290.tar.gz"
	fi
}

build_ruby() {
	cd build
	if [ ! -d "ruby" ]
	then
		mkdir ruby
	fi
	tar -xvzf ruby-1.9.2-p290.tar.gz
	cd ruby-1.9.2-p290
	./configure --enable-shared --with-arch=x86_64,i386 --prefix="$builddir/ruby" --with-libyaml-dir="$builddir/yaml"
	make
	make install
	cd ..
	tar cvzf "../resources/ruby-1.9.2-p290.universal.tar.gz" ruby
}

check_ruby() {
	if [ ! -f "resources/ruby-1.9.2-p290.universal.tar.gz" ]
	then
		get_ruby
		build_ruby
	fi
}

get_kidsruby() {
	/usr/local/bin/git clone --branch release git://github.com/hybridgroup/kidsruby.git
}

build_kidsruby() {
	tar cvzf "../resources/kidsruby.tar.gz" kidsruby
}

check_kidsruby() {
	if [ ! -f "resources/kidsruby.tar.gz" ]
	then
		cd build
		get_kidsruby
		build_kidsruby
		cd ..
	fi	
}

rundir="$(pwd)"
builddir="$rundir/build"

create_dirs
check_qt
check_git
check_yaml
check_ruby
check_kidsruby

echo "You still need to build the qtbindings gem manually, and put into resources directory, before you can build the installer."