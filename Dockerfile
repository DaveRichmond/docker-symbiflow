FROM daverichmond/fpga:latest

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive

RUN echo "Australia/Sydney" > /etc/timezone && \
	apt update && \
	apt install -y build-essential clang bison flex libreadline-dev \
		gawk tcl-dev libffi-dev git mercurial graphviz   \
		xdot pkg-config python python3 libftdi-dev \
		qt5-default python3-dev libboost-all-dev cmake \
		wget curl texinfo libgmp3-dev libmpfr-dev libmpc-dev && \
	apt install -y iverilog autoconf && \
	apt install -y libeigen3-dev python3-dev qt5-default clang-format \
		libboost-dev libboost-filesystem-dev libboost-thread-dev \
		libboost-program-options-dev libboost-python-dev \
		libboost-dev openocd && \
	apt install -y build-essential flex bison cmake fontconfig \
		libcairo2-dev libfontconfig1-dev libx11-dev libxft-dev \
		libgtk-3-dev perl liblist-moreutils-perl python time && \
	apt clean && \
	rm -Rf /var/cache/apt/*

COPY sudo.sh /usr/bin/sudo
RUN mkdir /build && cd /build && \
	git clone https://github.com/cliffordwolf/icestorm.git icestorm && \
	cd icestorm && \
		make && \
		make install && \
	cd - && \
	git clone https://github.com/cseed/arachne-pnr.git arachne-pnr && \
	cd arachne-pnr && \
		make && \
		make install && \
	cd - && \
	git clone https://github.com/YosysHQ/yosys && \
	cd yosys && \
		make && \
		make install && \
	cd - && \
	git clone --recursive https://github.com/SymbiFlow/prjtrellis && \
	cd prjtrellis/libtrellis && \
		cmake -DCMAKE_INSTALL_PREFIX=/usr/local . && \
		make && \
		make install && \
	cd - && \
	git clone https://github.com/YosysHQ/nextpnr nextpnr-ice40 && \
	cd nextpnr-ice40 && \
		cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local . && \
		make && \
		make install && \
	cd - && \
	git clone https://github.com/YosysHQ/nextpnr nextpnr-ecp5 && \
	cd nextpnr-ecp5 && \
		cmake -DARCH=ecp5 -DTRELLIS_ROOT=/build/prjtrellis . && \
		make && \
		make install && \
	cd - && \
	git clone http://git.veripool.org/git/verilator && \
	cd verilator && \
		autoconf && \
		./configure && \
		make && \
		make install && \
	cd - && \
	git clone https://github.com/verilog-to-routing/vtr-verilog-to-routing && \
	cd vtr-verilog-to-routing && \
		make && \
		make install && \
	cd - && \
	git clone https://github.com/cliffordwolf/picorv32 && \
		cd picorv32 && \
		yes y | make build-tools && \
	cd - && \
	cd / && rm -Rf build && \
	rm /usr/bin/sudo


COPY ./docker /docker
ENV PATH=$PATH:/opt/riscv/bin
WORKDIR /code
USER code

