## Workenvironment and Generation of DTS

```
## source altera enviorment file (if you have setup one), first, or add additional entries to PATH manually
$ . /opt/intelFPGA/18.1std/env.sh

$ export ARCH=nios2

$ export CROSS_COMPILE=nios2-elf-

$ export PATH=/opt/intelFPGA/18.1std/nios2eds/bin/gnu/H-x86_64-pc-linux-gnu/bin:${PATH}

$ cd ./github__u-boot/

$ cd ../../


## generate a ./arch/nios2/dts/<dts file>.dts using this tool

$ git clone git@github.com:Rubusch/sopc2dts.git
    Cloning into 'sopc2dts'...
    remote: Enumerating objects: 6, done.
    remote: Counting objects: 100% (6/6), done.
    remote: Compressing objects: 100% (5/5), done.
    remote: Total 3361 (delta 1), reused 4 (delta 1), pack-reused 3355
    Receiving objects: 100% (3361/3361), 895.99 KiB | 890.00 KiB/s, done.
    Resolving deltas: 100% (2337/2337), done.

$ cd ./sopc2dts/

$ make
    javac Sopc2DTS.java
    Note: Some input files use or override a deprecated API.
    Note: Recompile with -Xlint:deprecation for details.
    Note: Some input files use unchecked or unsafe operations.
    Note: Recompile with -Xlint:unchecked for details.
    echo "Implementation-Version: rel_14.0_RC3-46-g25a6d58" > manifest
    jar -cmef manifest Sopc2DTS sopc2dts.jar *.java *.class sopc2dts sopc_components_*.xml
    rm -f manifest

$ cd ..

$ ln -s ./sopc2dts/sopc2dts.jar .

$ java -jar ./sopc2dts.jar --force-altr -i ./nios2_de1soc.sopcinfo -o nios2_de1soc.dts

$ meld ./nios2_de1soc.dts ./software/github__u-boot/arch/nios2/dts/nios2_de1soc.dts


## enter the u-boot sources

$ cd ./software/github__u-boot


## generate or adjust a defconfig file

$ make defconfig lothars__uboot__nios2__02__defconfig

$ make menuconfig


## generate a ./include/configs/<header> with addresses to be used

$ vi ./include/configs/nios2_de1soc.h


## build

$ make clean && make -j8
```


## flashing

commands taken from Flash Programmer (NIOS2 Tool / Eclipse in Quartus) under Tools  

```
$ elf2flash --input="u-boot" --output="u-boot_epcq256_avl_mem.flash" --boot="u-boot.srec" --base=0x6000000 --end=0x8000000 --reset=0x6000000 --verbose 
    Nov 8, 2020 12:56:39 PM - (INFO) elf2flash: args = --input=u-boot --output=u-boot_epcq256_avl_mem.flash --boot=u-boot.srec --base=0x6000000 --end=0x8000000 --reset=0x6000000 --verbose
    Nov 8, 2020 12:56:39 PM - (FINE) elf2flash: Starting
    Nov 8, 2020 12:56:39 PM - (FINE) elf2flash: Done
```


## issues

* u-boot supports NIOS2 (f) using mmu and virtual addresses, as also the 16550 uart - all are non-free versions of Inte's "OpenCore plus" IP cores (as also hardware debugging)
* the freeware version will fail at flashing, and even creating a .hex file of the u-boot simply won't print out to the JTAG uart
