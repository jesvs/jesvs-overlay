# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson ninja-utils xdg-utils gnome2-utils

DESCRIPTION="A simple and modern GTK eBook reader"
HOMEPAGE="https://johnfactotum.github.io/foliate/"
SRC_URI="https://github.com/johnfactotum/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dictd espeak"

DEPEND="
	>=dev-util/meson-0.40
	sys-devel/gettext
	dev-libs/gjs
	net-libs/webkit-gtk
	dictd? ( app-text/dictd )
	espeak? ( app-accessibility/espeak )
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_schemas_update
}
