cd /media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/buildroot && \
unset PERL_MM_OPT && PATH=/bin/:/usr/local/bin:/usr/bin:/sbin make \
	'LKMC_PARSEC_BENCHMARK_SRCDIR="/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/submodules/parsec-benchmark"' \
	O=/media/sarnobat/unmirrored/trash/buildroot-arm.2019.02.6.cheat/linux-kernel-module-cheat/out/buildroot/build/default/x86_64 \
	V=0 \
	all \
;
