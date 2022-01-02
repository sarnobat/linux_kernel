## Docker buildroot
2022: I'm having better luck with this but I haven't reached the end yet
https://github.com/AdvancedClimateSystems/docker-buildroot/blob/master/scripts/run.sh

```
50930  docker ps
50931  ./scripts/run.sh make qemu_x86_64_defconfig menuconfig
50932  ./scripts/run.sh bash
50933  docker build -t  .
50934  docker run -i advancedclimatesystems/buildroot /bin/bash
50935  disown %1
50936  cd /media/sarnobat/unmirrored/trash/buildroot-2021.12/docker-buildroot
50937  docker run -i  advancedclimatesystems/buildroot /usr/bin/find
50938  docker run -i  advancedclimatesystems/buildroot /scripts/run.sh make qemu_x86_64_defconfig menuconfig
50939  docker run -i  advancedclimatesystems/buildroot make
50940  ./scripts/run.sh make raspberrypi2_defconfig menuconfig
50941  ./scripts/run.sh make menuconfig
50942  docker run -i --name buildroot_output advancedclimatesystems/buildroot /bin/echo "Data only."
50943  ./scripts/run.sh make menuconfig
50944  ./scripts/run.sh make qemu_x86_64_defconfig menuconfig
50945  ./scripts/run.sh make
50946  ./scripts/run.sh make | tee /tmp/docker.log &!
```
## Buildroot
with Buildroot it was much easier. 
* arm: https://stackoverflow.com/a/49349237/714112
* x86: https://unix.stackexchange.com/a/543075/7000

2021: Not Working on ubuntu 16 (which recently reached end of life)
2019: Worked on ubuntu 16 (when it was still supported)

## Buildroot cheat

https://github.com/cirosantilli/linux-kernel-module-cheat

2021-12-31: not working? Maybe I need to try on a version of Ubuntu that is still supported.
2021: Not Working on ubuntu 16 (which recently reached end of life)
2019: Worked on ubuntu 16 (when it was still supported)

Kernel:

    unset PERL_MM_OPT && PATH=/bin/:/usr/local/bin:/usr/bin:/sbin ./build --download-dependencies qemu-buildroot | tee /tmp/buildrootcheat.log
    run 
    
Inside guest

    ifup -a

Busybox:
~~There's no easy to rebuild packages like `wget` after adding print statements, because buildroot will download the source again and ovwerite it (I think). You'll have to drop back to Buildroot non-cheat version.

    unset PERL_MM_OPT && PATH=/bin/:/usr/local/bin:/usr/bin:/sbin  ./build-buildroot -- busybox-rebuild

Other useful things to note:
* `--ctrl-c-host`
* there's a graphml diagram

### Gdb

Kernel (https://cirosantilli.com/linux-kernel-module-cheat/#gdb-step-debug-kernel-post-boot):

    ./run
    ./run-gdb


### My attempts
```
fileserver2017 Thu 30 December 2021  3:27PM> cd /media/sarnobat/cadet/trash/buildroot && ls -l   /media/sarnobat/cadet/trash/buildroot
total 6208
-rw-rw-r--  1 sarnobat sarnobat 6342933 Oct  3  2019 buildroot-2019.02.6.tar.gz
drwxrwxr-x 16 sarnobat sarnobat    4096 Nov 11  2019 buildroot-arm.2019.02.6
drwxrwxr-x  3 sarnobat sarnobat    4096 Oct 27  2019 buildroot-arm.2019.02.6.cheat
lrwxrwxrwx  1 sarnobat sarnobat      55 Nov 21  2019 buildroot-cheat -> buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat
drwxrwxr-x 17 sarnobat sarnobat    4096 Nov  6  2019 buildroot-x86.2019-11-06.git
lrwxrwxrwx  1 sarnobat sarnobat      55 Nov 21  2019 cheat -> buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat
```
-------
# DEPRECATED. Use buildroot. I never got this fully working but 

## Download

Make sure you get a RELEASE, not the latest source.

## Compilation

* https://www.cyberciti.biz/tips/compiling-linux-kernel-26.html

```
make
```

## Running
```
qemu-system-x86_64 -kernel /boot/vmlinuz-5.3.0 -initrd /boot/initrd.img-5.3.0
```

## Kernel repository history

* https://www.youtube.com/watch?v=5iFnzr73XXk&t=5866s&ab_channel=DarrickWong
