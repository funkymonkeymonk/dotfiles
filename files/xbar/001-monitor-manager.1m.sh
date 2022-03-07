#!/bin/bash

# <xbar.title>Monitor Manager</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Will Weaver</xbar.author>
# <xbar.author.github>funkymonkeymonk</xbar.author.github>
# <xbar.desc>Helps you manage your monitors using via ddc</xbar.desc>
# <xbar.image>https://raw.githubusercontent.com/simonpeier/bitbar-dadjokes-plugin/master/screenshot.png</xbar.image>
# <xbar.dependencies>bash</xbar.dependencies>
# <xbar.dependencies>mirror-displays</xbar.dependencies>
# <xbar.dependencies>$DDC_APP</xbar.dependencies>
# <xbar.abouturl>https://simonpeier.github.io/bitbar-dadjokes-plugin/</xbar.abouturl>

MIRROR_APP=/opt/homebrew/bin/mirror
# Switch to ddcctl once it works for m1 chips until then use $DDC_APP
DDC_APP=/usr/local/bin/m1ddc

function exists() {
  app=$1
  command -v $app 1>/dev/null || { echo "$app is required but not installed."; exit;}
}

echo "Monitor Manager"
echo "---"

exists $MIRROR_APP
echo "Mirror Screens| shell=$MIRROR_APP terminal=false"
echo "---"
exists $DDC_APP

screen=1
screens=$($DDC_APP display list | wc -l)

# TODO: extract the id's into a file store that I load in.
# TODO: figure out what the UX for naming monitors is like
# TODO: Can I remap the order of the screens based on their positions?
while [ "$screen" -le "$screens" ]; do
  # TODO: for some reason this only works with a direct reference to m1ddc
  id=$(/usr/local/bin/m1ddc display list | sed  's/.*(\(.*\))/\1/' | sed -n "${screen}p")

  if [ $id == "10AC31A1-0000-0000-211E-0104B5502178" ]; then
    echo "Bottom Screen"
  elif [ $id == "10AC31A1-0000-0000-181E-0104B5502178" ]; then
    echo "Top Screen"
  else
    echo "Screen $id"
  fi

  # Is it possible to find out what input sources are available from the monitor
  echo "-- HDMI 1| shell=$DDC_APP param1=display param2=$screen param3=set param4=input param5=17 refresh=true"
  echo "-- HDMI 2| shell=$DDC_APP param1=display param2=$screen param3=set param4=input param5=17 refresh=true"
  echo "-- Display Port| shell=$DDC_APP param1=display param2=$screen param3=set param4=input param5=15  refresh=true"
  echo "-- USB C| shell=$DDC_APP param1=display param2=$screen param3=set param4=input param5=27 refresh=true"
  ((screen=screen+1))
done
