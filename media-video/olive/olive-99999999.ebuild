# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 gnome2-utils qmake-utils xdg-utils

DESCRIPTION="Professional open-source non-linear video editor."
HOMEPAGE="https://github.com/olive-editor/olive"
SRC_URI=""

EGIT_REPO_URI="https://github.com/olive-editor/olive"
if [[ ${PV} != *9999 ]]; then
	EGIT_COMMIT="${PV}"
	KEYWORDS="~amd64 ~x86"
fi

RESTRICT="mirror"
LICENSE="GPL-3"
SLOT="0"
IUSE="+frei0r"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5[png]
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtmultimedia:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	frei0r? ( media-plugins/frei0r-plugins )
	media-video/ffmpeg[vaapi,vdpau,wavpack]
	virtual/opengl"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

MY_PN="${PN}-editor"

src_prepare() {
	if ! use frei0r; then
		sed -e "s/DEFINES += QT_DEPRECATED_WARNINGS/DEFINES += QT_DEPRECATED_WARNINGS NOFREI0R/" \
			-i "${PN}.pro" || die 'sed failed!'
	fi

	eqmake5 "$(qmake-utils_find_pro_file)"
	eapply_user
}

src_install() {
	local size

	for size in 16 32 48 64 128 256 512; do
		insinto /usr/share/icons/hicolor/${size}x${size}/apps
		doins packaging/linux/icons/${size}x${size}/org.olivevideoeditor.Olive.png
	done

	insinto /usr/share/metainfo
	doins packaging/linux/org.olivevideoeditor.Olive.appdata.xml

	insinto /usr/share/mime/packages
	doins packaging/linux/org.olivevideoeditor.Olive.xml

	insinto /usr/share/olive-editor
	doins -r effects

	dobin "${MY_PN}"

	make_desktop_entry \
		"${MY_PN}" \
		"Olive" \
		"org.olivevideoeditor.Olive" \
		"AudioVideo;Recorder;" \
		"MimeType=application/vnd.olive-project;"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
