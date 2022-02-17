## Docker buildroot

-   [(recommended) Docker buildroot](#docker-buildroot)
    -   [Compilation](#compilation)
    -   [Running](#running)
-   [Docker buildroot-cheat](#docker-buildroot-cheat)
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
(recommended) From outside the container:
```
### minimal
cd /media/sarnobat/unmirrored/trash/buildroot-2021.12/docker-buildroot
docker build -t "advancedclimatesystems/buildroot" .
docker run -i --name buildroot_output advancedclimatesystems/buildroot /bin/echo "Data only."
./scripts/run.sh make qemu_x86_64_defconfig menuconfig
scripts/run.sh make
scripts/run.sh /buildroot_output/images/start-qemu.sh

### change some source code (kernel)
(optional) scripts/run.sh vi /buildroot_output/build/linux-5.4.58//init/main.c +/Run
(optional) scripts/run.sh make linux-rebuild

### change some source code (userland)
(optional) scripts/run.sh vi /buildroot_output/build/busybox-1.31.1/networking/wget.c +/download_one_url(const
(optional) scripts/run.sh make busybox-rebuild # if you change wget.c

Troubleshooting
It's fiddly trying to get userland changes to be copied into the new installation. Here are some suggestions:
1) Make sure you are running the right container (it is easier to not use `scripts/run.sh` to make sure multiple docker images aren't created)
2) 
```
# from inside the CORRECT container
cd /buildroot_output
make busybox-rebuild all
```
(instead of just make busybox-rebuild)
(credits: http://underpop.online.fr/b/buildroot/en/_using_buildroot_during_development.htm.gz)

# looks like you don't need to destroy and rebuild the container for busybox. -For init/main.c, I'm yet to determine how to deploy the changes.-
```

```
sudo service docker stop
sudo vi /etc/docker/daemon.json
{
   "data-root": "/media/sarnobat/ebay/trash/"
}
sudo chmod 777 /var/run/docker.sock
sudo service docker start
```
* The Docker container doesn't run the build on startup, it just installs the build tools. You have to kick off the build by running the Makefile

2022: I'm having better luck with this
https://github.com/AdvancedClimateSystems/docker-buildroot/blob/master/scripts/run.sh

From inside container:
root@b218928410d1: cd ~/buildroot/ && make

<s>After editing source code, you need to stop the container and create a new one. It will preserve your code changes to wget.c (how?) and</s> After building from the original commands (takes just a few mins) - you will see your new print statements. I don't understand exactly why it works but at least it does. I think it worked better when I used `scripts/run.sh` rather than interactively running the make file from inside the interactive container.



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
(recommended) From outside the container:
```
cd /media/sarnobat/unmirrored/trash/buildroot-2021.12/docker-buildroot
scripts/run.sh /buildroot_output/images/start-qemu.sh
```
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

## Docker Buildroot Cheat
Note: this won't allow you to change the source code, it just downloads a lot of precompiled binaries.
```
cd /media/sarnobat/unmirrored/trash/buildroot-2021.12/linux-kernel-module-cheat.2022-02
```
Then:
https://github.com/cirosantilli/linux-kernel-module-cheat#25-docker-host-setup 
* Note, install `docker.io`. `docker` doesn't work, even though it should.
* Do not confuse linux-kernel-module-cheat with linux-cheat. Ciro Santilli has a lot of great repositories and you need the kernel module one (linux-cheat is just for installing linux, not recompiling the source, I believe)

Ending log output:
```
mke2fs 1.45.6 (20-Mar-2020)
Creating regular file /root/lkmc/out.docker/buildroot/build/default/x86_64/images/rootfs.ext2
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: 2d241e73-1deb-481c-b97d-4d7ce97c92c6
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Copying files into the device: done
Writing superblocks and filesystem accounting information: done

>>>   Executing post-image script board/qemu/post-image.sh
+ /root/lkmc/out.docker/qemu/default/opt/qemu-img \
  -T pr_manager_run,file=/dev/null \
  convert \
  -f raw \
  -O qcow2 \
  /root/lkmc/out.docker/buildroot/build/default/x86_64/images/rootfs.ext2 \
  /root/lkmc/out.docker/buildroot/build/default/x86_64/images/rootfs.ext2.qcow2 \
;
time 02:25:03
```
## Buildroot
with Buildroot it was much easier. 
* arm: https://stackoverflow.com/a/49349237/714112
* x86: https://unix.stackexchange.com/a/543075/7000

2021: Not Working on ubuntu 16 (which recently reached end of life)
2019: Worked on ubuntu 16 (when it was still supported)

## Code comprehension

See also
/Volumes/git/sarnobat.git/yEd/2020/technology/linux_boot.graphml
/Volumes/git/sarnobat.git/yEd/2020/technology/linux_buildroot_cheat_build_deps.graphml
/Volumes/git/sarnobat.git/yEd/2020/technology/linux_buildroot_docker.graphml
* /Volumes/git/sarnobat.git/yEd/2020/technology/linux_call_graph.graphml
* /Volumes/git/sarnobat.git/yEd/2020/technology/minix_call_graph.graphml
   * (mentions `head.S`)

### boot

Kernel launch (from busybox?):
```
./buildroot_output/build/linux-5.4.58/arch/x86/kernel/setup.c:885:	printk(KERN_INFO "SRIDHAR Command line: %s\n", boot_command_line);
```
```
SRIDHAR Command line: rootwait root=/dev/vda console=tty1 console=ttyS0
```


```
./buildroot_output/build/linux-headers-5.4.58/init/main.c:	pr_notice("SRIDHAR: Kernel command line: %s\n", boot_command_line);
```

```
SRIDHAR Kernel command line: rootwait root=/dev/vda console=tty1 console=ttyS0
```


init launch:
```
./buildroot_output/build/linux-5.4.58/init/main.c:1048:	pr_info("SRIDHAR: Run %s as init process\n", init_filename);
```
```
SRIDHAR: Run /sbin/init as init process
```

piggy.S
vmlinux.c
Kernel boot parameters: start_qemu.sh



./buildroot_output/build/linux-5.4.58/arch/x86/kernel/head64.c:	start_kernel();
SRIDHAR start_kernel() 9

./buildroot_output/build/linux-5.4.58/arch/x86/kernel/smpboot.c:	pr_info("Allowing %d CPUs, %d hotplug CPUs\n",
./buildroot_output/build/linux-5.4.58/arch/x86/kernel/apic/apic.c:		pr_info("APIC: Switch to symmetric I/O mode setup\n");


Thanks to these sources for helping me find some of this code:
* https://tldp.org/HOWTO/Linux-i386-Boot-Code-HOWTO/init_main.html
* https://www.oreilly.com/library/view/linux-device-drivers/0596000081/ch16s03.html

### runtime log

* `/Users/sarnobat/mwk.git/snippets/basic_clusters_still_need_human_sorting/code/snpt_1633771455105_0__linux_code_comprehension_1.mwk`
* `/Users/sarnobat/mwk.git/snippets/basic_clusters_still_need_human_sorting/code/snpt_1633771455134_0__linux_code_comprehension_2.mwk`

### runtime log - boot
```
antec Mon 14 February 2022 11:08PM> scripts/run.sh /buildroot_output/images/start-qemu.sh
docker run --rm -ti --volumes-from buildroot_output -v /media/sarnobat/unmirrored/trash/buildroot-2021.12/docker-buildroot/data:/root/buildroot/data -v /medt
VNC server running on 127.0.0.1:5900
SRIDHAR start_kernel() 9
Linux version 5.4.58 (root@8544e6e8f1a1) (gcc version 9.3.0 (Buildroot 2020.08)) #6 SMP Tue Feb 15 07:07:54 UTC 2022
SRIDHAR Command line: rootwait root=/dev/vda console=tty1 console=ttyS0 loglevel=7 systemd.log_level=debug
x86/fpu: x87 FPU will use FXSAVE
BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x0000000007fdcfff] usable
BIOS-e820: [mem 0x0000000007fdd000-0x0000000007ffffff] reserved
BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
NX (Execute Disable) protection: active
SMBIOS 2.8 present.
DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
last_pfn = 0x7fdd max_arch_pfn = 0x400000000
x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
found SMP MP-table at [mem 0x000f5aa0-0x000f5aaf]
ACPI: Early table checksum verification disabled
ACPI: RSDP 0x00000000000F58C0 000014 (v00 BOCHS )
ACPI: RSDT 0x0000000007FE156F 000030 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 0x0000000007FE144B 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 0x0000000007FE0040 00140B (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
ACPI: FACS 0x0000000007FE0000 000040
ACPI: APIC 0x0000000007FE14BF 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
ACPI: HPET 0x0000000007FE1537 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
Zone ranges:
  DMA      [mem 0x0000000000001000-0x0000000000ffffff]
  DMA32    [mem 0x0000000001000000-0x0000000007fdcfff]
  Normal   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000000001000-0x000000000009efff]
  node   0: [mem 0x0000000000100000-0x0000000007fdcfff]
Zeroed struct page in unavailable ranges: 133 pages
Initmem setup node 0 [mem 0x0000000000001000-0x0000000007fdcfff]
ACPI: PM-Timer IO Port: 0x608
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[mem 0x08000000-0xfffbffff] available for PCI devices
Booting paravirtualized kernel on bare hardware
clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:1 nr_node_ids:1
percpu: Embedded 41 pages/cpu s127256 r8192 d32488 u2097152
Built 1 zonelists, mobility grouping on.  Total pages: 32102
SRIDHAR Kernel command line: rootwait root=/dev/vda console=tty1 console=ttyS0 loglevel=7 systemd.log_level=debug
Dentry cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
Inode-cache hash table entries: 8192 (order: 4, 65536 bytes, linear)
mem auto-init: stack:off, heap alloc:off, heap free:off
Memory: 113616K/130540K available (8195K kernel code, 446K rwdata, 1640K rodata, 876K init, 640K bss, 16924K reserved, 0K cma-reserved)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
rcu: Hierarchical RCU implementation.
rcu: 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=1.
rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
NR_IRQS: 4352, nr_irqs: 48, preallocated irqs: 16
Console: colour VGA+ 80x25
printk: console [tty1] enabled
printk: console [ttyS0] enabled
ACPI: Core revision 20190816
clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604467 ns
APIC: Switch to symmetric I/O mode setup
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
tsc: Unable to calibrate against PIT
tsc: using HPET reference calibration
tsc: Detected 2806.142 MHz processor
clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x2872ead4577, max_idle_ns: 440795243919 ns
Calibrating delay loop (skipped), value calculated using timer frequency.. 5612.28 BogoMIPS (lpj=11224568)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
Spectre V2 : Mitigation: Full AMD retpoline
Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
Speculative Store Bypass: Vulnerable
Freeing SMP alternatives memory: 24K
SRIDHAR kernel_init() 1
kernel_init_freeable() 1
smpboot: CPU0: AMD QEMU Virtual CPU version 2.5+ (family: 0x6, model: 0x6, stepping: 0x3)
Performance Events: PMU not available due to virtualization, using software events only.
rcu: Hierarchical SRCU implementation.
smp: Bringing up secondary CPUs ...
smp: Brought up 1 node, 1 CPU
smpboot: Max logical packages: 1
smpboot: Total of 1 processors activated (5612.28 BogoMIPS)
devtmpfs: initialized
random: get_random_u32 called from bucket_table_alloc.isra.0+0x75/0x160 with crng_init=0
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
futex hash table entries: 256 (order: 2, 16384 bytes, linear)
NET: Registered protocol family 16
cpuidle: using governor ladder
ACPI: bus type PCI registered
PCI: Using configuration type 1 for base access
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Added _OSI(Linux-Dell-Video)
ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
ACPI: 1 ACPI AML tables successfully acquired and loaded
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: Enabled 2 GPEs in block 00 to 0F
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A03:00: _OSC: OS supports [Segments HPX-Type3]
acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
pci_bus 0000:00: root bus resource [mem 0x08000000-0xfebfffff window]
pci_bus 0000:00: root bus resource [mem 0x100000000-0x17fffffff window]
pci_bus 0000:00: root bus resource [bus 00-ff]
pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
pci 0000:00:01.1: reg 0x20: [io  0xc0a0-0xc0af]
pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
pci 0000:00:02.0: [1234:1111] type 00 class 0x030000
pci 0000:00:02.0: reg 0x10: [mem 0xfd000000-0xfdffffff pref]
pci 0000:00:02.0: reg 0x18: [mem 0xfebd0000-0xfebd0fff]
pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
pci 0000:00:03.0: reg 0x10: [io  0xc080-0xc09f]
pci 0000:00:03.0: reg 0x14: [mem 0xfebd1000-0xfebd1fff]
pci 0000:00:03.0: reg 0x20: [mem 0xfe000000-0xfe003fff 64bit pref]
pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
pci 0000:00:04.0: reg 0x10: [io  0xc000-0xc07f]
pci 0000:00:04.0: reg 0x14: [mem 0xfebd2000-0xfebd2fff]
pci 0000:00:04.0: reg 0x20: [mem 0xfe004000-0xfe007fff 64bit pref]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
pci 0000:00:02.0: vgaarb: setting as boot VGA device
pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
pci 0000:00:02.0: vgaarb: bridge control possible
vgaarb: loaded
SCSI subsystem initialized
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Initialized.
PCI: Using ACPI for IRQ routing
clocksource: Switched to clocksource tsc-early
pnp: PnP ACPI init
pnp: PnP ACPI: found 6 devices
thermal_sys: Registered thermal governor 'step_wise'
thermal_sys: Registered thermal governor 'user_space'
clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
pci_bus 0000:00: resource 7 [mem 0x08000000-0xfebfffff window]
pci_bus 0000:00: resource 8 [mem 0x100000000-0x17fffffff window]
NET: Registered protocol family 2
tcp_listen_portaddr_hash hash table entries: 256 (order: 0, 4096 bytes, linear)
TCP established hash table entries: 1024 (order: 1, 8192 bytes, linear)
TCP bind hash table entries: 1024 (order: 2, 16384 bytes, linear)
TCP: Hash tables configured (established 1024 bind 1024)
UDP hash table entries: 256 (order: 1, 8192 bytes, linear)
UDP-Lite hash table entries: 256 (order: 1, 8192 bytes, linear)
NET: Registered protocol family 1
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
PCI: CLS 0 bytes, default 64
workingset: timestamp_bits=62 max_order=15 bucket_order=0
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler mq-deadline registered
io scheduler kyber registered
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
PCI Interrupt Link [LNKC] enabled at IRQ 11
PCI Interrupt Link [LNKD] enabled at IRQ 10
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
bochs-drm 0000:00:02.0: remove_conflicting_pci_framebuffers: bar 0: 0xfd000000 -> 0xfdffffff
bochs-drm 0000:00:02.0: remove_conflicting_pci_framebuffers: bar 2: 0xfebd0000 -> 0xfebd0fff
bochs-drm 0000:00:02.0: vgaarb: deactivate vga console
Console: switching to colour dummy device 80x25
[drm] Found bochs VGA, ID 0xb0c0.
[drm] Framebuffer size 16384 kB @ 0xfd000000, mmio @ 0xfebd0000.
[TTM] Zone  kernel: Available graphics memory: 56820 KiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
[drm] Found EDID data blob.
[drm] Initialized bochs-drm 1.0.0 20130925 for 0000:00:02.0 on minor 0
fbcon: bochs-drmdrmfb (fb0) is primary device
Console: switching to colour frame buffer device 128x48
bochs-drm 0000:00:02.0: fb0: bochs-drmdrmfb frame buffer device
virtio_blk virtio1: [vda] 122880 512-byte logical blocks (62.9 MB/60.0 MiB)
scsi host0: ata_piix
scsi host1: ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc0a0 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc0a8 irq 15
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
uhci_hcd: USB Universal Host Controller Interface driver
usbcore: registered new interface driver usb-storage
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
tsc: Refined TSC clocksource calibration: 2806.292 MHz
clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x287378a38b6, max_idle_ns: 440795214067 ns
clocksource: Switched to clocksource tsc
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
NET: Registered protocol family 10
Segment Routing with IPv6
sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
NET: Registered protocol family 17
IPI shorthand broadcast: enabled
sched_clock: Marking stable (1970765072, -45996236)->(1928296388, -3527552)
ALSA device list:
  No soundcards found.
ata2.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.5+ PQ: 0 ANSI: 5
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
EXT4-fs (vda): mounting ext2 file system using the ext4 subsystem
EXT4-fs (vda): mounted filesystem without journal. Opts: (null)
VFS: Mounted root (ext2 filesystem) readonly on device 254:0.
devtmpfs: mounted
SRIDHAR kernel_init_freeable() 9
Freeing unused kernel image memory: 876K
Write protecting the kernel read-only data: 12288k
Freeing unused kernel image memory: 2016K
Freeing unused kernel image memory: 408K
SRIDHAR kernel_init() 5
SRIDHAR kernel_init() 7
SRIDHAR kernel_init() 8
SRIDHAR: Run /sbin/init as init process
random: fast init done
EXT4-fs (vda): warning: mounting unchecked fs, running e2fsck is recommended
EXT4-fs (vda): re-mounted. Opts: (null)
ext2 filesystem being remounted at / supports timestamps until 2038 (0x7fffffff)
Starting syslogd: OK
Starting klogd: OK
Running sysctl: OK
Initializing random number generator: OK
Saving random seed: random: dd: uninitialized urandom read (512 bytes read)
OK
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

* 2022-02: not working with ubuntu 20. I guess it was only tested on Ubuntu 18.
* 2021-12-31: not working? Maybe I need to try on a version of Ubuntu that is still supported.
* 2021: Not Working on ubuntu 16 (which recently reached end of life)
* 2019: Worked on ubuntu 16 (when it was still supported)

Kernel:

    # https://github.com/cirosantilli/linux-kernel-module-cheat#qemu-buildroot-setup-getting-started
    ./setup
    # add deb-src repo: https://askubuntu.com/a/857433/126830
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
