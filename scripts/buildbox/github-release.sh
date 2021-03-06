#!/bin/bash
set -e

echo "TODO"
exit 1

echo '--- building'
./scripts/build-release.sh "windows" "386"
./scripts/build-release.sh "windows" "amd64"
./scripts/build-release.sh "linux" "amd64"
./scripts/build-release.sh "linux" "386"
./scripts/build-release.sh "linux" "arm"
./scripts/build-release.sh "darwin" "386"
./scripts/build-release.sh "darwin" "amd64"

# setup the current repo as a package - super hax.
mkdir -p gopath/src/github.com/buildbox
ln -s `pwd` gopath/src/github.com/buildbox/agent
export GOPATH="$GOPATH:`pwd`/gopath"

echo '--- install dependencies'
go get github.com/tools/godep
godep restore

echo '--- installing github-release'
go get github.com/buildbox/github-release

echo '--- download binaries'
rm -rf pkg
mkdir -p pkg
buildbox-agent artifact download "pkg/*" pkg

echo '--- release'
ruby scripts/publish_release.rb
