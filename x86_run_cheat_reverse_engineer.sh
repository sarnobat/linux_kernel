cd /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/build-buildroot && \
./build-buildroot \
	  --no-show-time \
	  ;

cd /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/buildroot && \
	  make \
	    O=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/buildroot/build/default/x86_64 \
	      BR2_EXTERNAL=../../buildroot_packages/kernel_modules:../../buildroot_packages/lkmc_many_files:../../buildroot_packages/parsec_benchmark:../../buildroot_packages/sample_package \
	        qemu_x86_64_defconfig \
		;


make O=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/buildroot/build/default/x86_64 BR2_EXTERNAL=../../buildroot_packages/kernel_modules:../../buildroot_packages/lkmc_many_files:../../buildroot_packages/parsec_benchmark:../../buildroot_packages/sample_package qemu_x86_64_defconfig


cat \
	  /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/buildroot_config/default \
	    '>>' \
	      /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/buildroot/build/default/x86_64/.config \
	      ;


cd /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/buildroot && \
	  make \
	    O=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/buildroot/build/default/x86_64 \
	      olddefconfig \
	      ;


cd /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/buildroot && \
	  make \
	    O=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/buildroot/build/default/x86_64 \
	      olddefconfig \
	      ;

cd /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/buildroot && \
unset PERL_MM_OPT && PATH=/bin/:/usr/local/bin:/usr/bin:/sbin make \
	'LKMC_PARSEC_BENCHMARK_SRCDIR="/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/parsec-benchmark"' \
	O=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/buildroot/build/default/x86_64 \
	V=0 \
	all \
;
