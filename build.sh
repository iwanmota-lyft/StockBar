#!/bin/bash
set -e

APP_NAME="StockBar"
BUILD_DIR=".build/release"
APP_BUNDLE="${APP_NAME}.app"

echo "Building ${APP_NAME}..."
swift build -c release

echo "Assembling ${APP_BUNDLE}..."
rm -rf "${APP_BUNDLE}"
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"

cp "${BUILD_DIR}/${APP_NAME}"            "${APP_BUNDLE}/Contents/MacOS/"
cp "StockBar/Info.plist"                 "${APP_BUNDLE}/Contents/"
cp "StockBar/Resources/AppIcon.icns"    "${APP_BUNDLE}/Contents/Resources/"

# Copy asset bundle if present
if [ -d "${BUILD_DIR}/StockBar_StockBar.bundle" ]; then
    cp -R "${BUILD_DIR}/StockBar_StockBar.bundle" "${APP_BUNDLE}/Contents/Resources/"
fi

echo "Signing ${APP_BUNDLE}..."
codesign --force --deep --sign - "${APP_BUNDLE}"

echo ""
echo "Done: ${APP_BUNDLE}"
echo "To install, run:"
echo "  cp -R ${APP_BUNDLE} /Applications/"
