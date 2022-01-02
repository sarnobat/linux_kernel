## Docker buildroot

-   [Docker buildroot](#docker-buildroot)
    -   [Compilation](#compilation)
    -   [Running](#running)
-   [Buildroot](#buildroot)
-   [Code comprehension](#code-comprehension)
    -   [runtime log](#runtime-log)
    -   [print statements in code](#print-statements-in-code)
-   [Old (not working)](#old-not-working)
    -   [Buildroot cheat](#buildroot-cheat)
        -   [Gdb](#gdb)
        -   [My attempts](#my-attempts)
-   [DEPRECATED. Use buildroot. I never got this fully working
    but](#deprecated.-use-buildroot.-i-never-got-this-fully-working-but)
    -   [Download](#download)
    -   [Compilation](#compilation-1)
    -   [Running](#running-1)
    -   [Kernel repository history](#kernel-repository-history)


### Compilation
2022: I'm having better luck with this
https://github.com/AdvancedClimateSystems/docker-buildroot/blob/master/scripts/run.sh

From inside container:
root@b218928410d1: cd ~/buildroot/ && make

After editing source code, you need to stop the container and create a new one. It will preserve your code changes to wget.c (how?) and after building from the original commands (takes just a few mins) - you will see your new print statements. I don't understand exactly why it works but at least it does.

```
cd /media/sarnobat/unmirrored/trash/buildroot-2021.12/docker-buildroot
```

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
#### Log output
```
Creating regular file /root/buildroot/output/images/rootfs.ext2
Creating filesystem with 61440 1k blocks and 15360 inodes
Filesystem UUID: 9fd1248a-5cbc-4177-acc2-f1506ec9389b
Superblock backups stored on blocks:
	8193, 24577, 40961, 57345

Allocating group tables: done
Writing inode tables: done
Copying files into the device: done
Writing superblocks and filesystem accounting information: done

ln -snf /root/buildroot/output/host/x86_64-buildroot-linux-uclibc/sysroot /root/buildroot/output/staging
>>>   Executing post-image script board/qemu/post-image.sh
root@b218928410d1:~/buildroot#
```
### Running

From inside container:
root@b218928410d1: ~/buildroot# sh /buildroot_output/images/start-qemu.sh 

run this to start it:
```
/buildroot_output/images/start-qemu.sh
/root/buildroot/output/images/start-qemu.sh
```
TODO: modify this for docker
```
qemu-system-x86_64 -kernel /boot/vmlinuz-4.15.0-133-generic -initrd /boot/initrd.img-4.15.0-133-generic
```
#### Log output
```
Starting network: udhcpc: started, v1.31.1
random: mktemp: uninitialized urandom read (6 bytes read)
udhcpc: sending discover
udhcpc: sending select for 10.0.2.15
udhcpc: lease of 10.0.2.15 obtained, lease time 86400
deleting routers
random: mktemp: uninitialized urandom read (6 bytes read)
adding dns 10.0.2.3
OK

Welcome to Buildroot
buildroot login:
```

```
# wget 'netgear.rohidekar.com'
SRIDHAR Connecting to netgear.rohidekar.com (73.222.175.43:80)
saving to 'index.html'
index.html           100% |********************************|  1718  0:00:00 ETA
'index.html' saved
```
The modified busybox seems to come from this native file:
```/media/sarnobat/ebay/trash/docker/volumes/d02844a1aa32dcc42ab075b1c2f63f5b7a70673bcaf6606ae9bdb0198ca11dd6/_data/target/bin/busybox```

#### Docker layers
```
  132  docker images -a
  133  docker image inspect f0f1e5b912da
```

## Buildroot
with Buildroot it was much easier. 
* arm: https://stackoverflow.com/a/49349237/714112
* x86: https://unix.stackexchange.com/a/543075/7000

2021: Not Working on ubuntu 16 (which recently reached end of life)
2019: Worked on ubuntu 16 (when it was still supported)

## Code comprehension

### runtime log

* `/Users/sarnobat/mwk.git/snippets/basic_clusters_still_need_human_sorting/code/snpt_1633771455105_0__linux_code_comprehension_1.mwk`
* `/Users/sarnobat/mwk.git/snippets/basic_clusters_still_need_human_sorting/code/snpt_1633771455134_0__linux_code_comprehension_2.mwk`

### print statements in code
```
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/cli_function.py:152:        print('  SRIDHAR cli_function::CliFunction::_do_main()')
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/cli_function.py:240:        print('  SRIDHAR cli_noexit')
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/cli_function.py:261:        print('SRIDHAR cli_function::CliFunction::cli_noexit()')
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/common.py:45:print('  SRIDHAR consts[root_dir] = ' + consts['root_dir'])
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/common.py:749:        print('  SRIDHAR: common::LkmcCliFunction::_init_env() env[buildroot_rootfs_raw_file] = ' + env['buildroot_rootfs_raw_file'])
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/common.py:1314:                        print('  SRIDHAR common::LkmcCliFunction::main()')
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/common.py:1367:        print('  SRIDHAR raw_to_qcow2()')
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/drivers/net/ethernet/intel/fm10k/fm10k_pci.c:1836:printk("SRIDHAR fm10k_up() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:266:printf("SRIDHAR connect() - begin 2\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/drivers/block/xen-blkback/xenbus.c:839:printf("SRIDHAR connect()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/tcp_output.c:1027:printk("SRIDHAR __tcp_transmit_skb() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/tcp_output.c:1129:printk("SRIDHAR __tcp_transmit_skb() - send_check\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/tcp_output.c:2331:printk("SRIDHAR tcp_write_xmit() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/tcp_ipv4.c:620:printk("SRIDHAR __tcp_v4_send_check()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/tcp_ipv4.c:1414:printk("SRIDHAR tcp_v4_syn_recv_sock() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/tcp_ipv4.c:2605:printk("SRIDHAR tcp_sk_init() - begin");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/af_inet.c:609:/*printf("SRIDHAR __inet_stream_connect()\n");*/
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/af_inet.c:610:/*fprintf("SRIDHAR __inet_stream_connect()\n");*/
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/af_inet.c:611:printk("SRIDHAR __inet_stream_connect() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/ip_output.c:101:printk("SRIDHAR __ip_local_out() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/ip_output.c:122:printk("SRIDHAR ip_local_out() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/ip_output.c:446:printk("SRIDHAR __ip_queue_xmit() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/ipv4/ip_output.c:1390:printk("SRIDHAR __ip_make_skb() - begin\b");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/socket.c:1821:printk("SRIDHAR __sys_connect()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/socket.c:1845:	printk("SRIDHAR SYSCALL_DEFINE3()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/socket.c:2317:printk("SRIDHAR __sys_sendmsg()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/socket.c:2705:printk("SRIDHAR socket.c::SYSCALL_DEFINE2()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/netfilter/core.c:270:	printk("SRIDHAR nf_hook_entry_head() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/net/compat.c:724:printk("SRIDHAR COMPAT_SYSCALL_DEFINE2()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/tools/usb/usbip/src/usbipd.c:430:printf("SRIDHAR do_getaddrinfo() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/include/linux/netfilter.h:216:printk("SRIDHAR nf_hook() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/include/net/ip.h:198:	printk("SRIDHAR ip_queue_xmit()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/include/net/l3mdev.h:178:printk("SRIDHAR l3mdev_l3_out() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/linux/include/net/l3mdev.h:194:	printk("SRIDHAR l3mdev_ip_out() - begin\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/qemu/roms/edk2/StdLib/BsdSocketLib/connect.c:69:  printf("SRIDHAR connect() - begin 3\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/qemu/roms/edk2/AppPkg/Applications/Python/Python-2.7.2/Modules/getaddrinfo.c:247:printf("SRIDHAR getaddrinfo()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/userland/posix/wget.c:30:printf("SRIDHAR wget\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/socket.c:1821:printk("SRIDHAR __sys_connect()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/socket.c:1845:	printk("SRIDHAR SYSCALL_DEFINE3()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/socket.c:2317:printk("SRIDHAR __sys_sendmsg()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/socket.c:2705:printk("SRIDHAR socket.c::SYSCALL_DEFINE2()\n");
/media/sarnobat/cadet/trash/buildroot/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/shell_helpers.py:368:            print('  SRIDHAR cmd = ' + ' '.join(cmd))
```
# Old (not working)
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
