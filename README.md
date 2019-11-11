
## Buildroot
with Buildroot it was much easier. https://stackoverflow.com/a/49349237/714112


    
## Buildroot cheat    

    unset PERL_MM_OPT && PATH=/bin/:/usr/local/bin:/usr/bin:/sbin ./build --download-dependencies qemu-buildroot | tee /tmp/buildroot.log
    run 
    
Inside guest

    ifup -a

There's no easy to rebuild packages like `wget` after adding print statements, because buildroot will download the source again and ovwerite it (I think). You'll have to drop back to Buildroot non-cheat version.

Other useful things to note:
* `--ctrl-c-host`
* there's a graphml diagram
    
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
