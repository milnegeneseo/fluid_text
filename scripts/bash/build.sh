#! /bin/bash

# FLUID TEXT PROJECT FOLDER (be sure to include final back slash )
# PROJFO='/Users/easterly/Documents/technical-services/fluid_text/'
PROJFO='/usr/local/bin/fluid_text/'

# Launch variables
while getopts s:h: option
do
        case "${option}"
        in
                s) ALTSOURCE=${OPTARG};;
                h) NEEDSHELP=${OPTARG};;
                
        esac
done

# Path variables for Mac/Ubuntu
XSLLOC="$PROJFO"'scripts/xslt/'
BSHLOC="$PROJFO"'scripts/bash/'
VMALOC="$PROJFO"'versioning_machine/'
if [ -z $ALTSOURCE ]; then 
	#TEILOC='/Users/easterly/Documents/technical-services/fluid_text/tei/'
	TEILOC='/usr/local/bin/fluid_text/tei/'	
else
	TEILOC="$ALTSOURCE"
fi

# timestamp for use in folder names
NOW=`command date "+%Y-%m-%dT%H:%M:%S"`

#
# error handling routine
# 
die()
{
    echo "ERROR: $@."
    exit 13
}

#
# Do we have a `saxon` cmd?
# 

which saxon > /dev/null  ||  die "You don't have a nice front-end to Saxon named \`saxon\` that I can use"

#
# Create a bunch of temporary working directories for either Mac or Linux
#
echo "Creating temporary directories..."

if [ -e /Applications/ ] && [ /Users/ ]; then
    TEMPDIR02=`mktemp -d /tmp/dT_rir_${NOW}_XXX`
    TEMPDIR04=`mktemp -d /tmp/dT_rir_one_${NOW}_XXX`
    TEMPDIR07=`mktemp -d /tmp/dT_rir_one_drk_${NOW}_XXX`
    TEMPDIR10=`mktemp -d /tmp/dT_rir_one_drk_vm_${NOW}_XXX`
    OPENCMD='open'
else
    TEMPDIR02=`mktemp -d --tmpdir=/tmp dT_rir_${NOW}_XXX`
    TEMPDIR04=`mktemp -d --tmpdir=/tmp dT_rir_one_${NOW}_XXX`
    TEMPDIR07=`mktemp -d --tmpdir=/tmp dT_rir_one_drk_${NOW}_XXX`
    TEMPDIR10=`mktemp -d --tmpdir=/tmp dT_rir_one_drk_vm_${NOW}_XXX`
    OPENCMD='xdg-open'
fi

# For debugging, we can watch what happens, as it happens
# be un-commenting the next line.
#set -o xtrace

#
# Do the work, relying heavily on saxon's directory-at-a-time
# capability.
# 
echo "Reprocessing internal revisions..."
saxon -xsl:$XSLLOC/reprocess_internal_revisions.xslt \
      -s:$TEILOC/ -o:$TEMPDIR02/

echo "Expanding critical apparatus (among other things)..."
saxon -xsl:$XSLLOC/one.xslt \
      -s:$TEMPDIR02/ -o:$TEMPDIR04/

echo "Cleaning up the versions... "
saxon -xsl:$XSLLOC/drop_revisions_keep_versions.xslt \
      -s:$TEMPDIR04/ -o:$TEMPDIR07/

echo "Building the Versioning Machine..."
saxon -xsl:$VMALOC/src/vmachine.xsl \
      -s:$TEMPDIR07/ -o:$TEMPDIR10/

#
# Rename last set to .html
# 
echo "Reticulating splines..."
ls $TEMPDIR10
for f in `ls $TEMPDIR10/*.xml` ; do
		echo $f
    mv $f `dirname $f`/`basename $f .xml`.html
done



#
# Open temp directory folder GUI so user can see results
# w/o resorting to commandline
# 
# had to move this script up one line
mkdir -p /tmp/saxon_out
cp $TEMPDIR10/*.html /tmp/saxon_out/
#  $OPENCMD "$TEMPDIR10"

cp -r $VMALOC /tmp/vm_out/
cp -r /tmp/saxon_out/*.html /tmp/vm_out/text/
#Bill Jones - adding this line to automatically update /var/www/html/
cp -r /tmp/vm_out/. /opt/rh/httpd24/root/var/www/html/

#commenting out the lines below -- doesn't work with Linux
#$OPENCMD "/tmp/saxon_out"
#$OPENCMD "/tmp/vm_out/text"

#Bill Jones - deleting temp files after rewrite to avoid clutter
rm -rf /tmp/dT_*
