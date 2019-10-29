
/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/qemu/default/opt/x86_64-softmmu/qemu-system-x86_64 \
  -machine pc \
  -device rtl8139,netdev=net0 \
  -gdb tcp::45457 \
  -kernel /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/linux/default/x86_64/arch/x86/boot/bzImage \
  -m 256M \
  -monitor telnet::45454,server,nowait \
  -netdev user,hostfwd=tcp::45455-:45455,hostfwd=tcp::45456-:22,id=net0 \
  -no-reboot \
  -smp 1 \
  -virtfs local,path=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/data/9p,mount_tag=host_data,security_model=mapped,id=host_data \
  -virtfs local,path=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out,mount_tag=host_out,security_model=mapped,id=host_out \
  -virtfs local,path=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/rootfs_overlay/x86_64,mount_tag=host_out_rootfs_overlay,security_model=map
  -virtfs local,path=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/rootfs_overlay,mount_tag=host_rootfs_overlay,security_model=mapped,id=host_roo
  -serial mon:stdio \
  -trace enable=load_file,file=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/run/qemu/x86_64/0/trace.bin \
  -device edu \
  -append 'root=/dev/vda nopat console_msg_format=syslog nokaslr norandmaps panic=-1 printk.devkmsg=on printk.time=y rw console=ttyS0 - lkmc_home=/lkmc' \
  -nographic \
  -serial tcp::45458,server,nowait \
  -drive file=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/buildroot/build/default/x86_64/images/rootfs.ext2.qcow2,format=qcow2,if=virtio,sn
  -cpu max \
;
