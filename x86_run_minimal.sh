/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/qemu/default/opt/x86_64-softmmu/qemu-system-x86_64 \
  -kernel /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/linux/default/x86_64/arch/x86/boot/bzImage \
  -append 'root=/dev/vda  console=ttyS0' \
  -nographic \
  -drive file=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/buildroot/build/default/x86_64/images/rootfs.ext2,if=virtio \
;
