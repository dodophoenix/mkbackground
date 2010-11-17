#!/bin/bash
#
# ./mkBackground.sh [WallpaperDuration] [transitionDuration] [outputfilename.xml]
#
# example one:
# ./mkBackground.sh 
# example two:
# ./mkBackground.sh 60.0 15.0 slideshow.xml
#

DUR=$1;
TRANS=$2;
OUTFILE=$3;
if [ -z "$DUR" ] ; then
	DUR="240.0"; # default wallpaper duration
fi

if [ -z "$TRANS" ] ; then
	TRANS="15.0"; # default transition duration 
fi

if [ -z "$OUTFILE" ] ; then
	OUTFILE="slideshow.xml"; # default filename outfilename
fi

# function that builds the xml file
function mkFileData {

	PREFIX=`cat <<END 
<background>\\n
\\t<starttime>\\n
\\t\\t<year>2010</year>\\n
\\t\\t<month>08</month>\\n
\\t\\t<day>04</day>\\n
\\t\\t<hour>00</hour>\\n
\\t\\t<minute>00</minute>\\n
\\t\\t<second>00</second>\\n
\\t</starttime>
END`;

	echo -e $PREFIX;

	FIRST="";
	LAST="";
	PREV="";
	LASTTAG="";

	export IFS=$'\n' # newline als field separator
	for i in $(find ./ -maxdepth 1 -type f | grep -i ".png\|.jpg")
	do 
		echo "";
		FILE=`pwd`"/"`basename "$i" `;
	
		if [ -z "$FIRST" ] ;then
			FIRST=$FILE;
		fi

		if [ -n "$LASTTAG" ];then
			echo $LASTTAG;
		fi 
		
		if [ -n "$PREV" ] ;	then
			echo "	<transition>";
			echo "		<duration>$TRANS</duration>";
			echo "		<from>$PREV></from>";
			echo "		<to>$FILE></to>";
			echo "	</transition>";
		fi

		LASTTAG="	<static><duration>$DUR</duration><file>$FILE</file></static>";
		PREV=$FILE;
		LAST=$FILE;	
	done
	
	echo "";
	echo $LASTTAG;
	echo "	<transition>";
	echo "		<duration>$TRANS</duration>";
	echo "		<from>$LAST</from>";
	echo "		<to>$FIRST</to>";
	echo "	</transition>";
	echo "</background>";

}
mkFileData > $OUTFILE;

# was für ne scheisse 
#
# 1. cdata tags not interpreted correctly by nautilus xml parser 
# 2. special chars in filename for bg animation not interpreted correctly -> may end up in endles nautilus folder open tags when using > as filename which is # absolutly a valid filename -> only animation not static tag
# 3. duplication in xml -> not the way xml should be used -> redundance -> add mastertag containing stransition and static ? 
# 4. improve -> add default values for transition and duration and just specifiy other values


