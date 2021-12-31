
## Buildroot
with Buildroot it was much easier. 
* arm: https://stackoverflow.com/a/49349237/714112
* x86: https://unix.stackexchange.com/a/543075/7000
    
## Buildroot cheat

https://github.com/cirosantilli/linux-kernel-module-cheat

2021-12-31: not working? 
`--2021-12-31 14:12:47--  http://isl.gforge.inria.fr/isl-0.18.tar.xz`

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
# DEPRECATED. Use buidlroot. I never got this fully working but 

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
