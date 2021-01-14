#!/bin/sh
echo "Building NodeJS application" &&
npm run --silent build &&
cp package.json package-lock.json dist &&
cd dist &&
echo "Installing producton deependencies" &&
npm install --​quiet --prod &&
echo "Compress lambda source in latest.zip" &&
zip -r -m -qq latest.zip . &&
echo "\nBuild complete."
