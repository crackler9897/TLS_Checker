#!/bin/bash
# RUN ON STANDBY

searchVip()
{
    x=$(tmsh -q -c 'cd /'"$env"'; show ltm virtual '"$1"' profiles' | grep 'TLS Protocol Version 1.0                                                            0')
    y=$(tmsh -q -c 'cd /'"$env"'; show ltm virtual '"$1"' profiles' | grep 'TLS Protocol Version 1.1                                                            0')
      if [ -n "$x" && -n "$y" ]; then
          echo "$1" >> "$HOME"/TLS_1_2_only_"$env".txt
        else 
          echo "$1" >> "$HOME"/TLS_offenders_"$env".txt
      fi
}

pauseIt()
{
  sleep .5
  echo -n "*"
  sleep .5
  echo -n "*"
  sleep .5
  echo -n "*"
  sleep .5
  echo ""
  echo ""
}

partitions=($(tmsh -q -c 'cd /; list auth partition one-line' | awk '{ print $3 }'))

echo ""
echo ""
echo ""
echo "Partitions: ${partitions[@]} *ALL*"
echo ""
  
pauseIt() 

read -p "What partition should we check?...<enter> to check all partitions: " env
sleep .5
echo ""

if [ -n "$env" ]; then
      echo "env defined is /${env}"
    else
      echo "env defined is /"
fi

pauseIt()

vipsArr=($(tmsh -q -c 'cd /'"$env"'; list ltm virtual one-line recursive' | awk '{print $3}' ))
echo "${vipsArr[@]}"

for i in ${vipsArr[@]}; do
  if [ -n "$env" ]; then
    i="${env}/${i}"
  fi
  echo "$i"
  #searchVip($i)
done


#   1.  Read in partition (env)
#   2.  Create array of all virtual names based on partition
#   **3.**  Run 'show ltm virtual' for each virtual and determine if 1.0 or 1.1 is being used
#   4.  Output to file/list
#
#
#
#
#
#
#
#