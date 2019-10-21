# DEPRECATED. Use buidlroot. I never got this fully working but with Buildroot it was much easier. https://stackoverflow.com/a/49349237/714112

-------
# IGNORE
linux source code
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
