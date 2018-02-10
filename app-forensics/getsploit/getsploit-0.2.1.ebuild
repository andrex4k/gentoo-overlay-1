# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit eutils python-r1

DESCRIPTION="Command line utility for searching and downloading exploits"
HOMEPAGE="https://github.com/vulnersCom/getsploit"
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vulnersCom/getsploit"
	KEYWORDS=""
else
	SRC_URI="https://github.com/vulnersCom/getsploit/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

RESTRICT="mirror"
LICENSE="LGPL-3"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}"

src_prepare() {
	eapply "${FILESDIR}"
	eapply_user
}

src_install() {
	dodoc README.md

	python_foreach_impl python_doscript getsploit.py
	make_wrapper \
		"getsploit" \
		"python3 /usr/bin/getsploit.py"
}

pkg_postinst() {
	elog
	elog "See documentation: https://github.com/vulnersCom/getsploit#how-to-use"
	elog
}
