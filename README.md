# fluid_text

## What can I do here?

You can make edits to the <a href="http://digitalthoreau.geneseo.edu/text/00.html">Digital Thoreau: Fluid Text</a> website by editing XML files localed in the <a href="https://github.com/milnegeneseo/fluid_text/tree/master/tei">fluid_text/tei/</a> folder in this repository.  Once you have made changes to a file and saved them, they will be synced with the server and a new version of the Digital Thoreau: Fluid Text site will be created and made available via <a href="http://digitalthoreau.geneseo.edu/">http://digitalthoreau.geneseo.edu/</a>.

## How does this work?

There is a cron job on the digitalthoreau.geneseo.edu server that runs every minute.  This job does the following things:

1.  navigates to the folder where the fluid_text files are located on the server
2.  performs a 'git pull' command to pull down any changes made in the GitHub GUI (or any changes pushed up to Git).  The files we are mainly concerned with are the .xml files
3.  runs the build.sh bash script to run transformations on the .xml files
4.  The build.sh script then copies the transformed files to the directory where the live webpages are located, and deletes the temp files that it creates in the process.
