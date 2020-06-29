# MODELSIM TESTBENCH

## RESOURCES

https://wiki.archlinux.org/index.php/Altera_Design_Software
http://twoerner.blogspot.com/2017/10/running-modelsim-altera-from-quartus.html



## ISSUE: ModelSim is not working

* Quartus 18.1: ModelSim is free! Most startup initialization errors seem to end up in a missing license message when started from Quartus, thus try to debug from terminal.  

* Quartus 18.1: Change ModelSim's ``vco`` file as follows  

```
$ diff -purN ./modelsim_ase/vco.orig ./modelsim_ase/vco
--- ./modelsim_ase/vco.orig     2020-06-29 17:38:58.228011802 +0200
+++ ./modelsim_ase/vco  2020-06-29 17:40:44.088223237 +0200
@@ -207,7 +207,7 @@ case $vco in
           2.[5-9]*)         vco="linux" ;;
           2.[1-9][0-9]*)    vco="linux" ;;
           3.[0-9]*)                    vco="linux" ;;
-          *)                vco="linux_rh60" ;;
+          *)                vco="linux" ;;
         esac
         if [ ! -x "$dir/$vco/vsim" ]; then
           if [ -x "$dir/linuxle/vsim" ]; then
```

* Quartus 18.1: Make sure i386 libraries are installed, test with   

```
$ ldd /opt/intelFPGA/18.1std/modelsim_ase/bin/../linux_rh60/vish | grep "not found"
        libX11.so.6 => not found
        libXext.so.6 => not found
        libXft.so.2 => not found
        libXrender.so.1 => not found
        libfontconfig.so.1 => not found
```

if not, configure ``multiach`` (in my case for debian) as follows, and install the missing libraries  

```
$ sudo dpkg --add-architecture i386
$ sudo apt-get update
$ sudo aptitude install libxext6:i386
$ sudo aptitude install libxtst6:i386
$ sudo aptitude install libxft2:i386
```

* Quartus 18.1: most likely ModelSim now will throw something like this  

```
$ vsim
Error in startup script:
Initialization problem, exiting.

Initialization problem, exiting.

    while executing
"InitializeINIFile quietly"
    invoked from within
"ncFyP12 -+"
    (file "/mtitcl/vsim/vsim" line 1)
** Fatal: Read failure in vlm process (0,0)
```

typically, this boils down to a manual installation of an older version of the freetype font  
(location can vary, here I install the font into a folder inside my ModelSim installation)  

```
$ cd /opt/intelFPGA/18.1std/modelsim_ase
$ wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.7.tar.bz2
$ tar xjf freetype-2.4.7.tar.bz2
$ cd ./freetype-2.4.7
$ CFLAGS=-m32 ./configure --prefix=/opt/intelFPGA/18.1std/modelsim_ase/freetype-2.4.7/freetype
$ make
$ make install
```

set up an ``env.sh`` or add to the env.sh  

```
if [[ "" == "$(echo ${LD_LIBRARY_PATH} | grep 'freetype/lib' )" ]] ; then export LD_LIBRARY_PATH=/opt/intelFPGA/18.1std/modelsim_ase/freetype-2.4.7/freetype/lib:$LD_LIBRARY_PATH ; fi
```

before starting Quartus and/or ModelSim, source the ``env.sh`` (in general such environment file is helpful for other env variables and extension of path anyway, alternatively precipitate quartus adjustments to profile.d, bashrc, and other linux config files  

then start Quartus as follows
```
$ source ./env.sh
$ quartus &
```
