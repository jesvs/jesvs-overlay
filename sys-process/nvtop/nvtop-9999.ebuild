# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="(h)top like task monitor for AMD, Intel, NVIDIA, … GPUs"
HOMEPAGE="https://github.com/Syllo/nvtop"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Syllo/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Syllo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

IUSE="unicode video_cards_intel video_cards_amdgpu video_cards_nvidia video_cards_freedreno"

RDEPEND="
	video_cards_intel?  ( virtual/udev )
	video_cards_amdgpu? ( x11-libs/libdrm[video_cards_amdgpu] )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers )
	video_cards_freedreno? ( x11-libs/libdrm[video_cards_freedreno] )
	sys-libs/ncurses:0=
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
        cmake_src_prepare

		sed -i 's/AMDGPU_SUPPORT OR MSM_SUPPORT/AMDGPU_SUPPORT OR MSM_SUPPORT OR NVIDIA_SUPPORT/' src/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCURSES_NEED_WIDE=$(usex unicode)
		-DINTEL_SUPPORT=$(usex video_cards_intel)
		-DNVIDIA_SUPPORT=$(usex video_cards_nvidia)
		-DAMDGPU_SUPPORT=$(usex video_cards_amdgpu)
		-DMSM_SUPPORT=$(usex video_cards_freedreno)
	)

	cmake_src_configure
}
