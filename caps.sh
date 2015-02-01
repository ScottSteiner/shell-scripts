#!/bin/bash
# Edited version by Scott Steiner <nothingfinerthanscottsteiner@gmail.com>
# Can be downloaded from https://github.com/ScottSteiner/shell-scripts
#
# Original version at http://www.angelfire.com/planet/moviecaps/

# Default values
DEFAULT_INTERVAL=30
DEFAULT_FS=16
VERSION="0.6"
SVN_VERSION="\$Revision: 19 $"

# Set default values
OUTPUT_DIRECTORY="/media/samba/Misc/Caps/"
OFFSET=0
BACKOFFSET=6 #Percentage
MAXIMUM_FILESIZE=3072kb
INTERVAL=$DEFAULT_INTERVAL
FONTSIZE=$DEFAULT_FS
SCALE_FACTOR=1
TEMP=`mktemp -d`
PREFIX="${TEMP}/cap_"
NUM_COLS=4
NUM_CAPS=16
RESIZE_SPEC=500x500
SPACING=4
SHADOW=-shadow
BORDER=2
unset CROP_SPEC DO_PAUSE

function debug () {
cat <<EOF
OFFSET       = ${OFFSET}
BACKOFFSET   = ${BACKOFFSET}
LENGTH       = ${LENGTH}
INTERVAL     = ${INTERVAL}
NUM_CAPS     = ${NUM_CAPS}
STEPS        = ${STEPS}
FONTSIZE     = ${FONTSIZE}
SCALE_FACTOR = ${SCALE_FACTOR}
PREFIX       = ${PREFIX}
EOF
}

function print_help () {
cat <<EOF

Usage: `basename $0` [OPTIONS] <filename of the movie>
     --grid                                Plain 3x3 grid of screencaps.
                                           Same as --noshadow --noheader --spacing 0 --columns 3 --number 3 --border 0 --no-timestamps
     --biggrid                             Big 10x10 grid of screencaps.
                                           Same as --noshadow --noheader --spacing 0 --columns 10 --number 10 --border 0 --no-timestamps --scale .20
     --hugegrid                            Huge grid constrained to 5000 pixels

 -o, --offset <start in seconds>           Start capturing here (default: ${OFFSET}).
 -k, --backoffset <end in percentage>      End capturing here (default: ${BACKOFFSET}%).
 -e, --end <end in seconds>                End capturing here (default: length of the movie). Specifying a negative ends capturing at movielength-value.
 -i, --interval <time between screencaps>  Interval between screencaps (default: ${DEFAULT_INTERVAL}).
 -n, --number <number of screencaps>       Specify how many screencaps should be taken. This overwrites -i.

 -s, --scale <scale factor>                Scale the screencaps by this factor (default: no scaling).

 -c, --crop <crop-spec>                    Crop the images using Imagemagick. See ImageMagick(1) details.
 -r, --resize <resize-spec>                Resize the images within the boundary of a resolution using Imagemagick. See ImageMagick(1) details.
 -a, --autocrop                            Trim the picture's edges via an simple heuristic.

 -p, --prefix <prefix>                     Prefix of the screencaps (default: ${PREFIX}).

 -x, --no-timestamps                       Don't write timestamps into the screencaps.
 -f, --fontsize <fontsite in pixels>       Default is ${DEFAULT_FS}.

     --noshadow                            Disables the shadow effect
     --noheader                            Disables the header
 -b, --border <border thickness>           Sets the border thickness (default: ${BORDER}).

 -g, --spacing <spacing>                   Number of pixels between screencaps (default: ${SPACING}).
 -l, --columns <number of columns>         Number of columns the final picture sheets should have (default: ${NUM_COLS}).
     --pause                               Wait before composing the final picture. You may modify or delete some of the
                                           screencaps before they are composed into the final image.
     --dont-delete-caps                    Do not delete the screen captures afterwards.
     --output                              Sets the output directory (default: ${OUTPUT_DIRECTORY})
     --filename				   Specifies an output filename

 -h, --help                                Print this message and exit.
 -V, --version                             Print the version and exit.

EOF
}

# Check if the required software is available
for i in getopt mplayer convert printf awk; do
  if [ ! `which ${i}` ]; then
    echo "Error: Unable to find ${i}."
    exit 4
  fi
done

# Parse the arguments
TEMP_OPT=`getopt -a \
          -o e:,o:,k:,i:,n:,f:,s:,p:,h,V,c:,x,a,l:,g:,b: \
	  --long output:,filename:,hugegrid,biggrid,grid,end:,offset:,interval:,number:,fontsize:,scale:,prefix:,help,version,crop:,resize:,autocrop,no-timestamps,columns:,spacing:,pause,dont-delete-caps,noshadow,border:,noheader,backoffset: \
	  -- "$@"`

if [ $? != 0 ]; then
  echo "Error executing getopt. Terminating..." >&2
  exit 1
fi

eval set -- "$TEMP_OPT"

while true ; do
  case "$1" in
    -o|--offset|-offset)	OFFSET=$2; shift 2;;
    -k|--backoffset|-backoffset)BACKOFFSET=$2; shift 2;;
       --output|-output)        OUTPUT_DIRECTORY=$2; shift 2;;
       --filename|-filename)    OUTPUT_FILENAME="$2"; shift 2;;
    -e|--end|-end)		LENGTH=$2; shift 2;;
    -i|--interval|-interval)	INTERVAL=$2; shift 2;;
    -n|--number|-number)	NUM_CAPS=$2; shift 2;;
    -f|--fontsize|-fontsize)	FONTSIZE=$2; shift 2;;
    -s|--scale|-scale)		SCALE_FACTOR=$2; shift 2;;
    -p|--prefix|-prefix)	PREFIX=$2; shift 2;;
    -c|--crop|-crop)		CROP_SPEC=$2; shift 2;;
    -r|--resize|-resize)	RESIZE_SPEC=$2; shift 2;;
    -a|--autocrop|-autocrop)	AUTOCROP=1; shift 1;;
    -x|--no-timestamps|-no-timestamps)	NO_TIMESTAMPS=1; shift 1;;
    -l|--columns|-column)	NUM_COLS=$2; shift 2;;
    -g|--spacing|-spacing)	SPACING=$2; shift 2;;
       --noshadow|-noshadow)    unset SHADOW; shift 1;;
       --noheader|-noheader)    DO_NOT_ADD_HEADER=1; shift 1;;
       --grid|-grid)            DO_NOT_ADD_HEADER=1; unset SHADOW;NUM_CAPS=9;NUM_COLS=3;BORDER=0;SPACING=0;NO_TIMESTAMPS=1; shift 1;;
       --biggrid|-biggrid)      SCALE_FACTOR=.40;DO_NOT_ADD_HEADER=1; unset SHADOW;NUM_CAPS=100;NUM_COLS=10;BORDER=0;SPACING=0;NO_TIMESTAMPS=1; shift 1;;
       --hugegrid|-biggrid)     HUGEGRID=1;DO_NOT_ADD_HEADER=1; unset SHADOW;BORDER=0;SPACING=0;NO_TIMESTAMPS=1; shift 1;;
    -b|--border|border)         BORDER=$2; shift 2;;
       --pause|-pause)		DO_PAUSE=1; shift 1;;
       --dont-delete-caps|-dont-delete-caps)	DO_NOT_DELETE_CAPS=1; shift 1;;
    -h|--help|-help)		print_help; exit 0;;
    -V|--version|-version)	echo "`basename ${0}`, Version ${VERSION} [SVN: ${SVN_VERSION}]"; exit 0;;
    --) shift ; break ;;
    *) echo "Unknown parameter $1." ; exit 1 ;;
  esac
done

# Handle the filename of the movie
MOVIEFILENAME="${1}"
if [ -z "${MOVIEFILENAME}" ]; then
  echo "Error: Please specify a filename for the movie."
  print_help
  exit 2
fi

if [ ! -r "${MOVIEFILENAME}" ]; then
  echo "Error: Unable to read file \"$MOVIEFILENAME\"."
  exit 3
fi

function get_movie_info () {
  eval `mplayer -vo null -ao null -frames 0 -identify "${MOVIEFILENAME}" 2> /dev/null| grep ID_LENGTH`
  eval `mplayer -vo null -ao null -frames 0 -identify "${MOVIEFILENAME}" 2> /dev/null| grep ID_VIDEO`
  LENGTH=`echo $ID_LENGTH | awk '{print int($1)}'`
  MOVIELENGTH=`printf "%02d:%02d:%02d" $((($LENGTH/3600)%24)) $((($LENGTH/60)%60)) $(($LENGTH%60))`
  MOVIEASPECTRATIONUM=`echo "scale=1; ${ID_VIDEO_WIDTH}/${ID_VIDEO_HEIGHT}"|bc`
  case "$MOVIEASPECTRATIONUM" in
	1.7)
		MOVIEASPECTRATIO=" (16:9)"
		;;
	1.3)
		MOVIEASPECTRATIO=" (4:3)"
		;;
	2.4|2.3)
		MOVIEASPECTRATIO=" (2.40:1)"
		;;
	1.8)
		MOVIEASPECTRATIO=" (1.85:1)"
		;;
	*)
		MOVIEASPECTRATIO=""
		;;
  esac
  MOVIERESOLUTION="${ID_VIDEO_WIDTH}x${ID_VIDEO_HEIGHT}${MOVIEASPECTRATIO}"
}
# Handle -e
if [ -z $LENGTH ]; then
  # acquire length of the movie
  get_movie_info
fi
if [ $LENGTH -le 0 ]; then
  BACK_OFFSET=$LENGTH
  get_movie_info
  LENGTH=$(($LENGTH+$BACK_OFFSET))
fi
if [ -n "$HUGEGRID" ]; then
  RESIZE_SPEC=200x200
  RESIZE_HEIGHT=$(( ${ID_VIDEO_HEIGHT}*200/${ID_VIDEO_WIDTH} ))
  NUM_COLS=$(( 5000/200 ))
  NUM_ROWS=$(( 5000/$RESIZE_HEIGHT ))
  NUM_CAPS=$(( $NUM_ROWS*$NUM_COLS ))
fi

CAPTURE_LEN=$(( ($LENGTH*(100-$BACKOFFSET)/100)-$OFFSET ))
# if -n is not given...
if [ -z $NUM_CAPS ]; then
  # calculate STEPS using INTERVAL
  STEPS=$((${CAPTURE_LEN}/${INTERVAL}))
else
  # calculate INTERVAL using NUM_CAPS
  STEPS=${NUM_CAPS}
  INTERVAL=`echo "scale=5; ${CAPTURE_LEN}/${STEPS}" | bc`
fi
# construct parameters for scaling
if [ ${SCALE_FACTOR} == 1 ]; then
  SCALE_OPTS=""
else
  SCALE_OPTS="-sws 2 -vf scale -xy ${SCALE_FACTOR} -zoom"
fi

## End: Argument Parsing

declare -a SCREENCAPS
echo -n "Making $STEPS screencaps in ${INTERVAL}s intervals, beginning at $OFFSET seconds and stopping at $CAPTURE_LEN seconds:  00% (0/$STEPS)"
for i in `seq 1 $(($STEPS))`
do
  POSITION=`printf "%.0f" $(echo "scale=2;$OFFSET+$i*$INTERVAL" | bc)`
  # extract picture from movie
  mplayer -really-quiet -ao null -vo jpeg:quality=100:outdir=${TEMP} -ss $POSITION -frames 1 $SCALE_OPTS "${MOVIEFILENAME}" > /dev/null 2> /dev/null
  # crop the picture
  if [ ! -z $CROP_SPEC ]; then
    mogrify -crop ${CROP_SPEC} ${TEMP}/00000001.jpg
  fi
  # resize the picture
  if [ ! -z $RESIZE_SPEC ]; then
    mogrify -resize ${RESIZE_SPEC} ${TEMP}/00000001.jpg
  fi
  if [ ! -z $AUTOCROP ]; then
    mogrify -fuzz 10% -trim ${TEMP}/00000001.jpg
  fi

  # Insert timestamp
  if [ -z $NO_TIMESTAMPS ]; then
    # calculate current offset in seconds
    TIMESTAMP=`printf "%02d:%02d:%02d" $((($POSITION/3600)%24)) $((($POSITION/60)%60)) $(($POSITION%60))`
    # insert timestamp
    convert ${TEMP}/00000001.jpg -gravity SouthEast -pointsize $FONTSIZE \
	-stroke '#000' -strokewidth 2 -annotate +1-1 "$TIMESTAMP" -stroke none -fill '#fff' -annotate +1-1 "$TIMESTAMP" ${TEMP}/00000001.jpg
  fi

  # rename captured picture to prefix_seqnum.jpg
  FNAME=`printf "%s%08d.jpg" "${PREFIX}" $i`
  mv ${TEMP}/00000001.jpg $FNAME

  # Append the filename to the array SCREENCAPS
  SCREENCAPS[${#SCREENCAPS[*]}]=$FNAME

  PERCENT="$i*100/$STEPS"
  PROGRESS=`echo "scale=0; $PERCENT" | bc -l`
  PROGRESS=`printf "%02d%% ($i/$STEPS)" $PROGRESS`
  PROGRESSLENGTH=`expr length "$PROGRESS"`
  BACKSPACES=`eval printf '\\\b%.0s' {1..$PROGRESSLENGTH}`
  echo -en "$BACKSPACES$PROGRESS"
done

if [ ! -z $DO_WAIT ]; then
  echo "Waiting (as requested). Press Enter to continue."
  read
fi

# Strip the extension from the movie's filename and append .jpg
MOVIESHORTFILENAME=`basename "${MOVIEFILENAME}"`
OUTPUT_FILE=${MOVIESHORTFILENAME}

for i in .avi .mpg .mpeg .mp4 .vob .vcd .ogm .mkv .webm .flv .wmv; do
  OUTPUT_FILE=`basename "${OUTPUT_FILE}" $i`
done
if [ $NUM_COLS -ne 4 ] || [ $NUM_CAPS -ne 16 ]; then
  if [ $NUM_COLS -gt $NUM_CAPS ]; then
    NUM_COLS=$NUM_CAPS
  fi
  ROWS=$((($NUM_CAPS+($NUM_COLS-1))/$NUM_COLS))
  OUTPUT_FILE="$OUTPUT_FILE ${NUM_COLS}x${ROWS}"
fi

if ! [ -z "$OUTPUT_FILENAME" ]; then
	OUTPUT_FILE="$OUTPUT_FILENAME"
fi
OUTPUT_FILE="${OUTPUT_DIRECTORY}${OUTPUT_FILE}.jpg"

montage -background none -border ${BORDER} -bordercolor black -geometry +${SPACING}+${SPACING} ${SHADOW} -tile ${NUM_COLS}x ${SCREENCAPS[*]} "${TEMP}/montage.png"
if [ -z $DO_NOT_ADD_HEADER ] ; then
  MOVIEFILESIZE=$(stat -c%s "$MOVIEFILENAME")
  MOVIEFILESIZEHUMAN=`echo $MOVIEFILESIZE | awk '{ split( "B KB MB GB TB PB EB ZB YB" , v ); s=1; while( $1>=1024 ){ $1/=1024; s++ } print int($1) v[s] }'`
  MOVIEFILESIZE=`echo $MOVIEFILESIZE | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'`
  LABEL="File Name: ${MOVIESHORTFILENAME}\nFile Size: ${MOVIEFILESIZEHUMAN} (${MOVIEFILESIZE} bytes)\nResolution: $MOVIERESOLUTION\nDuration: ${MOVIELENGTH}"
  convert "${TEMP}/montage.png" -define jpeg:extent=$MAXIMUM_FILESIZE -gravity NorthWest -background none -density 100 -splice 0x80\
	-pointsize 12 -annotate +5+2 "${LABEL}" -background "#EAEAEA" -append -layers merge "${OUTPUT_FILE}"
else
  convert "${TEMP}/montage.png" -define jpeg:extent=$MAXIMUM_FILESIZE "${OUTPUT_FILE}"
fi
#rm ${TEMP}/montage.png

# Delete the screen captures
if [ -z $DO_NOT_DELETE_CAPS ] ; then
  rm ${SCREENCAPS[*]}
fi
echo "...done."
