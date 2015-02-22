FROM ubuntu

RUN apt-get update
RUN apt-get install -y git build-essential expect doxygen u-boot-tools curl qemu-system-arm gcc-avr binutils-avr avr-libc lib32z1 libelf-dev vim python

# Install Codesourcery ARM compiler and set path
RUN curl -s -L "http://www.codesourcery.com/sgpp/lite/arm/portal/package5353/public/arm-none-eabi/arm-2009q3-68-arm-none-eabi-i686-pc-linux-gnu.tar.bz2" | bunzip2 -d --stdout | sudo tar -C /opt -xf -
ENV PATH $PATH:/opt/arm-2009q3/bin

# Install Montavista tools for DaVinci DM36x
ADD montavista_davinci_tools.tgz /opt

# Build and install known-working simavr version
RUN git clone git://gitorious.org/simavr/simavr.git /tmp/simavr
RUN cd /tmp/simavr && git reset --hard 90da54280f2ff2d91f2e51f41a5e747c56db6f94
RUN cd /tmp/simavr/simavr && make
RUN cd /tmp/simavr/simavr && make install
RUN ldconfig
RUN rm -rf /tmp/simavr

# Clean up
RUN apt-get -y clean
