#!/bin/bash

# <xbar.title>Monitor Manager</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Will Weaver</xbar.author>
# <xbar.author.github>funkymonkeymonk</xbar.author.github>
# <xbar.desc>Helps you manage your monitors using via ddc</xbar.desc>
# <xbar.image>https://raw.githubusercontent.com/simonpeier/bitbar-dadjokes-plugin/master/screenshot.png</xbar.image>
# <xbar.dependencies>bash</xbar.dependencies>
# <xbar.abouturl>https://simonpeier.github.io/bitbar-dadjokes-plugin/</xbar.abouturl>

function exists() {
  app=$1
  command -v $app 1>/dev/null || { echo "$app is required but not installed."; exit;}
}

echo "Monitor Manager"
echo "---"

exists mirror
echo "Mirror Screens| shell=mirror terminal=false"
echo "---"
# Switch to ddcctl once it works for m1 chips until then use m1ddc
exists m1ddc

screen=1
screens=$(m1ddc display list | wc -l)
screens=2

# Can I remap the order of the screens based on their positions?
while [ "$screen" -le "$screens" ]; do
  # Can I create friendly names for the monitor and have them match?
  # This is a cludge that I'm not even sure will persist. I know that there is info available via ddc
  if [ $screen -eq 1 ]; then
    echo "Bottom Screen"
  elif [ $screen -eq 2 ]; then
    echo "Top Screen"
  else
    echo "Screen $screen"
  fi

  # Is it possible to find out what input sources are available from the monitor
  echo "-- HDMI 1| shell=m1ddc param1=display param2=$screen param3=set param4=input param5=17 refresh=true"
  echo "-- HDMI 2| shell=m1ddc param1=display param2=$screen param3=set param4=input param5=17 refresh=true"
  echo "-- Display Port| shell=m1ddc param1=display param2=$screen param3=set param4=input param5=15  refresh=true"
  echo "-- USB C| shell=m1ddc param1=display param2=$screen param3=set param4=input param5=27 refresh=true"
  ((screen=screen+1))
done
