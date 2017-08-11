# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Thanks for "betagarden" (https://gpo.zugaina.org/Overlays/betagarden/media-gfx/arcad-c1-bin — updated)

EAPI=6

inherit unpacker gnome2-utils xdg-utils

# Depends
TUX_LIB_N="tux-library"
TUX_LIB_V="${PV}"
TUX_COM_N="tux-common"
TUX_COM_V="2017.36"

# Samples
TUX_TINY_N="tuxcad-tiny"
TUX_TINY_V="2017.03"
TUX_SMALL_N="tuxcad-small"
TUX_SMALL_V="${TUX_TINY_V}"

DESCRIPTION="ARCAD C1 is a 2D/3D architectural CAD for GNU/Linux"
HOMEPAGE="http://cad.arcad.de/products_architecture_arcad.php"
SRC_URI="amd64?	( http://myarcad.spdns.de/packages/FREE-Linux/pool/zesty/main/t/${TUX_LIB_N}/${TUX_LIB_N}_${TUX_LIB_V}_amd64.deb
                  http://myarcad.spdns.de/packages/FREE-Linux/pool/zesty/main/t/${TUX_COM_N}/${TUX_COM_N}_${TUX_COM_V}_amd64.deb
                  http://myarcad.spdns.de/packages/FREE-Linux/pool/zesty/main/a/${PN}/${PN}_${PV}_amd64.deb

                  samples? ( http://myarcad.spdns.de/packages/FREE-Linux/pool/zesty/main/t/${TUX_TINY_N}/${TUX_TINY_N}_${TUX_TINY_V}_amd64.deb 
                             http://myarcad.spdns.de/packages/FREE-Linux/pool/zesty/main/t/${TUX_SMALL_N}/${TUX_SMALL_N}_${TUX_SMALL_V}_amd64.deb ) 
                )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE="povray samples"
RESTRICT="mirror strip"
S="${WORKDIR}"

DEPEND=""
RDEPEND="!app-office/lxfibu-c1-bin
	>=sys-libs/glibc-2.14
	>=media-libs/fontconfig-2.8.0
	>=media-libs/freetype-2.2.1
	>=dev-libs/libxml2-2.6.27
	>=dev-db/mariadb-5.5.57
	>=x11-libs/motif-2.3.5:0
	media-libs/libpng:1.2
	media-libs/mesa
	virtual/glu
	virtual/jpeg
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXp
	x11-libs/libXrender
	x11-libs/libXt
	povray? ( >=media-gfx/povray-3.7.0.0 )"

src_install() {
	local app=${PN%%-bin}
	local target=_Linux_x86_64_4.10.0

	cp -R . "${D}"/ || die
	dosym /opt/tuxbase/projects/${app}/${app}.desktop /usr/share/applications/${app}.desktop || die
	dosym lib${target} /opt/tuxbase/lib || die
	dosym bin${target} /opt/tuxbase/projects/${app}/bin || die
	dosym /opt/tuxbase/projects/${app}/start /usr/bin/${app} || die

	dosym /usr/lib64/libjpeg.so /opt/tuxbase/lib/libjpeg.so.62 || die

	# Ensure that the shipped libXm.so.4.0.3 is used rather than the system-wide libXm.so.4.0.4 or we get:
	# symbol lookup error: /opt/tuxbase/lib/libtxtbl.so.2010.02: undefined symbol: _XmXftSetClipRectangles
	dosym /usr/lib64/libXm.so.4.0.4 /opt/tuxbase/lib/libXm.so.4 || die
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}