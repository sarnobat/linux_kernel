# You may first need to make the qemu binaries
unset PERL_MM_OPT && PATH=/bin/:/usr/local/bin:/usr/bin:/sbin make BR2_JLEVEL="$(nproc)" HOST_QEMU_OPTS='--enable-sdl --with-sdlabi=2.0' 

unset PERL_MM_OPT && PATH=/bin/:/usr/local/bin:/usr/bin:/sbin make busybox-rebuild linux-rebuild && output/host/usr/bin/qemu-system-aarch64 \
  -M virt \
  -cpu cortex-a57 \
  -nographic \
  -smp 1 \
  -kernel output/images/Image \
  -append "root=/dev/vda console=ttyAMA0" \
  -netdev user,id=eth0 \
  -device virtio-net-device,netdev=eth0 \
  -drive file=output/images/rootfs.ext4,if=none,format=raw,id=hd0 \
  -device virtio-blk-device,drive=hd0 \
;

