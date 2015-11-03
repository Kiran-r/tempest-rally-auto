#!/bin/sh
dir=$(pwd)
echo $dir
git clone https://github.com/openstack/tempest
VENVDIR="$dir"/rally
if [ ! -d "tempest" ]; then
    git clone https://github.com/openstack/tempest
    sh run_tests.sh
fi
cp tempest.conf ./tempest/etc/tempest.conf
cd tempest
source .venv/bin/activate
testr run tempest
if [ ! -d "rally" ]; then
    git clone https://github.com/openstack/rally
    VENVDIR="$dir"/rally
    cd VENVDIR
    ./install_rally.sh --target "$VENVDIR"
    rally-manage db recreate
fi
cd "$dir"/rally
source bin/activate
for entry in "tasks"/*.yaml "tasks"/*.json
do
    rally task start ./"$entry"
done
