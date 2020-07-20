# QUARTUS

## RESOURCES

https://github.com/CTSRD-CHERI/quartus-install.git


## INSTALLATION

Basically for me I only install cyclone5 support, and ModelSim   

```
$ git clone https://github.com/CTSRD-CHERI/quartus-install.git && cd quartus-install
$ ./quartus-install.py --fix-libpng 18.1lite /opt/intelFPGA/18.1std modelsim c5 opencl eds update_1
```

## CONFIGURATION

Finally I set up a environment file to be sourced  

```
$ cat /opt/intelFPGA/18.1std/env.sh

export QT_X11_NO_MITSHM=1
export ALTERAPATH="/opt/intelFPGA/18.1std"
export ALTERAOCLSDKROOT="${ALTERAPATH}/hls"
export QUARTUS_ROOTDIR="${ALTERAPATH}/quartus"
export QUARTUS_ROOTDIR_OVERRIDE="$QUARTUS_ROOTDIR"
export QSYS_ROOTDIR="${ALTERAPATH}/quartus/sopc_builder/bin"
if [[ "" == "$(echo ${PATH} | grep 'quartus/bin' )" ]]; then export PATH="$PATH:${ALTERAPATH}/quartus/bin" ; fi
if [[ "" == "$(echo ${PATH} | grep 'nios2eds/bin' )" ]] ; then export PATH="$PATH:${ALTERAPATH}/nios2eds/bin" ; fi
if [[ "" == "$(echo ${PATH} | grep 'sopc_builder/bin' )" ]]; then export PATH="$PATH:${QSYS_ROOTDIR}" ; fi
if [[ "" == "$(echo ${PATH} | grep 'modelsim_ase/bin' )" ]]; then export PATH="$PATH:${ALTERAPATH}/modelsim_ase/bin" ; fi
if [[ "" == "$(echo ${LD_LIBRARY_PATH} | grep 'freetype/lib' )" ]] ; then export LD_LIBRARY_PATH=/opt/intelFPGA/18.1std/modelsim_ase/freetype-2.4.7/freetype/lib:$LD_LIBRARY_PATH ; fi
```

and my own starter script for Quartus (or the Quartus starter scripts so to speak...)  

```
$ cat /usr/local/bin/quartus.sh

source /opt/intelFPGA/18.1std/env.sh
if [[ "" == "$(pidof quartus)" ]] ; then
	echo "starting quartus 18.1"
	quartus --64bit &
else
	echo "FAILED: another instance of quartus is already running"
fi
```



# FURTHER NOTES

#### ModelSim

https://github.com/Rubusch/vhdl/blob/master/notes/vhdl/testbench.md


#### VHDL Type Conversion

https://github.com/Rubusch/vhdl/blob/master/notes/vhdl/type_conversion.md


#### VHDL General Notes or Miscellaneaous

https://github.com/Rubusch/vhdl/blob/master/notes/vhdl/vhdl.md


#### Howto: Setup a Basic Project (slideshow)

https://github.com/Rubusch/vhdl/tree/master/notes/howto__quartus-blinky


#### Howto: Basic Usage of ModelSim

https://github.com/Rubusch/vhdl/tree/master/notes/howto__quartus-modelsim-testbench




# ISSUES

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


## ISSUE: Top-level design entity "blablabla" is undefined

the top-level entity has to be named as the project name, if the names differ, then it must be set explicitely  
append the following to the .qsf file  

```
$ vi ./*.qsf
    (...)
    set_global_assignment -name TOP_LEVEL_ENTITY <my entity>
```


## ISSUE: Number of processors has not been specified which may cause overloading on shared machines.

...Set the global assignment NUM_PARALLEL_PROCESSORS in your QSF to an appropriate value for best performance.  

```
$ vi ./*.qsf
    (...)
    set_global_assignment -name NUM_PARALLEL_PROCESSORS 4
```

## ISSUE: ModelSim, strange warnings...

example
```
# ** Warning: (vsim-3116) Problem reading symbols from linux-gate.so.1 : can not open ELF file.
```

can be turned off or need to be ignored (the above seems to come from jtagd running in foreground  
either
```
run_modelsim: $(test_info)
   $(MAKE) -C $(root_dir)/sim build_modelsim; \
   printf "" > $(test_results); \
   cd $(bld_dir); \
   vsim -c -do "run -all" +nowarn3691 \
   +test_info=$(test_info) \
   +test_results=$(test_results) \
   +imem_pattern=$(imem_pattern) \
   +dmem_pattern=$(dmem_pattern) \
   work.$(top_module) \
   $(MODELSIM_OPTS)

where:
    -c
    command line mode

    -do "run -all"
    "run -all" means that it will run util the simu stops by itself

    +nowarn3691
    remove a bunch a crazy modelsim warning as "# ** Warning: (vsim-3116) Problem reading symbols from linux-gate.so.1 : can not open ELF file."

    +test_info=$(test_info) +test_results=$(test_results) +imem_pattern=$(imem_pattern) +dmem_pattern=$(dmem_pattern)
    from the help: "Option accessible by PLI routine mc_scan_plusargs" This will be given to the PLI lib (weirdly the argument to enable the PLI is not present)

    work.$(top_module)
    the entity you are going to simulate as a top (module: $(top_module) from lib work)

    $(MODELSIM_OPTS)
    given by your makefile
```

alternatively also jtagd could be set into foreground
```
$ killall jtagd
$ jtagd --foreground --debug
```
