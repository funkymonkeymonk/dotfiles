#!/bin/bash

# <xbar.title>Monitor Manager</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Will Weaver</xbar.author>
# <xbar.author.github>funkymonkeymonk</xbar.author.github>
# <xbar.desc>Helps you manage your monitors using via ddc</xbar.desc>
# <xbar.image>https://raw.githubusercontent.com/simonpeier/bitbar-dadjokes-plugin/master/screenshot.png</xbar.image>
# <xbar.dependencies>bash</xbar.dependencies>
# <xbar.abouturl>https://simonpeier.github.io/bitbar-dadjokes-plugin/</xbar.abouturl>

# Confirm that mirror is installed and accessible
# Confirm that ddcctl/m1ddc is install and accessible
# Switch to ddcctl once it works for m1 chips until then use m1ddc

function exists() {
  app=$1
  command -v $app 1>/dev/null || { echo "$app is required but not installed."; exit;}
}

echo "Monitor Manager"
echo "---"

exists mirror
exists m1ddc

echo "Mirror Screens| shell=mirror terminal=false"
echo "---"
echo "Top Screen"
echo "-- HDMI 1| shell=m1ddc param1=display param2=2 param3=set param4=input param5=17 refresh=true"
echo "-- HDMI 2| shell=m1ddc param1=display param2=2 param3=set param4=input param5=17 refresh=true"
echo "-- Display Port| shell=m1ddc param1=display param2=2 param3=set param4=input param5=15  refresh=true"
echo "-- USB C| shell=m1ddc param1=display param2=2 param3=set param4=input param5=27 refresh=true"
echo "---"
echo "Bottom Screen"
echo "-- HDMI 1| shell=m1ddc param1=display param2=2 param3=set param4=input param5=17 refresh=true"
echo "-- HDMI 2| shell=m1ddc param1=display param2=2 param3=set param4=input param5=17 refresh=true"
echo "-- Display Port| shell=m1ddc param1=display param2=2 param3=set param4=input param5=15  refresh=true"
echo "-- USB C| shell=m1ddc param1=display param2=2 param3=set param4=input param5=27 refresh=true"
