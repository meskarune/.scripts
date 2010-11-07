#!/bin/bash
# calendar.sh
# copyright 2010 by Mobilediesel
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

date=$(date '+%F')
DAY=${date:8:2}
# m="-m" # uncomment this line for starting the week on Monday instead of Sunday.
cal=$(cal $m)
prev=$(cal $m $(date '+%-m %Y' --date="${date:0:7}-15 -1 month")|sed 's/ *$//;/^$/d'|tail -1)
next=$(cal $m $(date '+%-m %Y' --date="${date:0:7}-15 +1 month")|sed '/^ *&/d;1,2d;s/^ *//'|head -1)
if [ ${#next} == 19 ] ;then next=$'\n'"\${color grey} $next"
else next="\${color grey}  $next"
fi
if [ ${#prev} == 20 ]; then prev="$prev"$'\n '
else prev="$prev  "
fi
dates=$(remind -s|cut -d ' ' -f1|uniq|cut -d '/' -f3|sed "/$DAY/d")
current=$(echo "${cal:42}"|sed -e '/^ *$/d' -e 's/^ *1\>/1/')
for i in $dates; do
current=$(echo "$current"|sed -e "s/\<${i/#0/}\>/\${color green}&\${color 99ccff}/")
done
current=$(echo "$current"|sed -e "s/\<${DAY/#0/}\>/\${color white}&\${color 99ccff}/" -e 's/ *$//')
echo -e "\${color grey}${cal:0:21}\${color 808080}${cal:21:21}\${color grey}$prev\${color 99ccff}$current$next"
