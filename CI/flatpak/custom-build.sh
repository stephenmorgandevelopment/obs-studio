

PRODUCT_NAME="OBS-Studio"

CHECKOUT_DIR="$(/usr/bin/git rev-parse --show-toplevel)"
DEPS_BUILD_DIR="${CHECKOUT_DIR}/../obs-build-dependencies"
BUILD_DIR="${BUILD_DIR:-build}"
BUILD_CONFIG=${BUILD_CONFIG:-RelWithDebInfo}
CI_SCRIPTS="${CHECKOUT_DIR}/CI/scripts/macos"
CI_WORKFLOW="${CHECKOUT_DIR}/.github/workflows/main.yml"
CI_MACOS_CEF_VERSION=$(/bin/cat ${CI_WORKFLOW} | /usr/bin/sed -En "s/[ ]+MACOS_CEF_BUILD_VERSION: '([0-9]+)'/\1/p")
CI_DEPS_VERSION=$(/bin/cat ${CI_WORKFLOW} | /usr/bin/sed -En "s/[ ]+MACOS_DEPS_VERSION: '([0-9\-]+)'/\1/p")
CI_VLC_VERSION=$(/bin/cat ${CI_WORKFLOW} | /usr/bin/sed -En "s/[ ]+VLC_VERSION: '([0-9\.]+)'/\1/p")
CI_SPARKLE_VERSION=$(/bin/cat ${CI_WORKFLOW} | /usr/bin/sed -En "s/[ ]+SPARKLE_VERSION: '([0-9\.]+)'/\1/p")
CI_QT_VERSION=$(/bin/cat ${CI_WORKFLOW} | /usr/bin/sed -En "s/[ ]+QT_VERSION: '([0-9\.]+)'/\1/p" | /usr/bin/head -1)
CI_MIN_MACOS_VERSION=$(/bin/cat ${CI_WORKFLOW} | /usr/bin/sed -En "s/[ ]+MIN_MACOS_VERSION: '([0-9\.]+)'/\1/p")
NPROC="${NPROC:-$(sysctl -n hw.ncpu)}"



cmake \
        -DCMAKE_CXX_FLAGS="-std=c++11 -stdlib=libc++ -Wno-deprecated-declarations"\
        -DCMAKE_EXE_LINKER_FLAGS="-std=c++11 -stdlib=libc++"\
        -DCMAKE_OSX_DEPLOYMENT_TARGET=${MIN_MACOS_VERSION:-${CI_MIN_MACOS_VERSION}} \
        ..


cmake -DENABLE_SPARKLE_UPDATER=ON \
        -DCMAKE_OSX_DEPLOYMENT_TARGET="10.13.4:10.15.7"\
        -DQTDIR="/tmp/obsdeps" \
        -DSWIGDIR="/tmp/obsdeps" \
        -DDepsPath="/tmp/obsdeps" \
        -DVLCPath="/Users/smorgan/repos/obs-build-dependencies/vlc-${VLC_VERSION:-${CI_VLC_VERSION}}" \
        -DBUILD_BROWSER=ON \
        -DBROWSER_LEGACY="$(test "${MACOS_CEF_BUILD_VERSION:-${CI_MACOS_CEF_VERSION}}" -le 3770 && echo "ON" || echo "OFF")" \
        -DWITH_RTMPS=ON \
        -DCEF_ROOT_DIR="${DEPS_BUILD_DIR}/cef_binary_${MACOS_CEF_BUILD_VERSION:-${CI_MACOS_CEF_VERSION}}_macosx64" \
        -DCMAKE_BUILD_TYPE="${BUILD_CONFIG}" \
        ..

cmake -DCMAKE_OSX_DEPLOYMENT_TARGET=10.13 \
  -DQTDIR="/tmp/obsdeps" -DSWIGDIR="/tmp/obsdeps" \
  -DDepsPath="/tmp/obsdeps" -DDISABLE_PYTHON=ON ..



cmake -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15.7 -DDISABLE_PYTHON=ON -G Xcode ..

/.github/workflows/main.yml
