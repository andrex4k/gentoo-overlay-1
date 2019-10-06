# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Stress-Terminal UI monitoring tool"
HOMEPAGE="https://amanusk.github.io/s-tui/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/amanusk/s-tui"
else
	MY_PV="${PV%%_pre}"
	SRC_URI="https://github.com/amanusk/s-tui/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+stress"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	stress? ( app-benchmarks/stress )"
