# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit git-r3 python-r1 linux-mod versionator

DESCRIPTION="Linux process hunter"
HOMEPAGE="https://gitlab.com/nowayout/prochunter"
SRC_URI=""

EGIT_REPO_URI="https://gitlab.com/nowayout/prochunter"
if [[ ${PV} != *9999 ]]; then
	EGIT_COMMIT="94f703f71719bd70014f24835fd542e2b8b12ded"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="kernel_linux"

RDEPEND="${PYTHON_DEPS}
	dev-python/psutil[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

pkg_setup() {
	if use kernel_linux; then
		MODULE_NAMES="${PN}(misc:${S}:${S})"
		BUILD_TARGETS="clean all"

		linux-mod_pkg_setup
	else
		die "Could not determine proper ${PN} package"
	fi
}

src_prepare() {
	if use kernel_linux; then
		# Change KMOD_PATH param
		sed -i \
			-e "s:KMOD_PATH=\"./prochunter.ko\":KMOD_PATH=\"/lib/modules/${KV_FULL}/misc/prochunter.ko\":" \
			prochunter.py || die "sed failed!"

		# Fix error message "fatal error: linux/sched/signal.h: No such file or directory"
		# removing "#include <linux/sched/signal.h>" line is not critical 
		# for >=4.10 version of the kernel (https://gitlab.com/nowayout/prochunter/issues/1#note_46894766)
		if version_is_at_least "${KV_FULL}" "4.10"; then
			sed -i -e "/#include <linux\/sched\/signal.h>/d" prochunter.c || die "sed failed!"
		fi
	fi

	eapply_user
}

src_compile() {
	if use kernel_linux; then
		MAKEOPTS="-j1" linux-mod_src_compile
	fi
}

src_install() {
	use kernel_linux && linux-mod_src_install

	python_scriptinto /usr/sbin
	python_foreach_impl python_doscript ${PN}.py

	dodoc README.md
}

pkg_postinst() {
	use kernel_linux && linux-mod_pkg_postinst

	elog
	elog "See documentation: https://gitlab.com/nowayout/prochunter/blob/master/README.md#how-to-use"
	elog
}
