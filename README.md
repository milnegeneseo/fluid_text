# *Walden*: A Fluid-Text Edition

This repository holds XML-TEI and other files for Digital Thoreau's [fluid-text edition of *Walden*](http://digitalthoreau.org/fluid-text-toc/).

Changes made here are pushed to the edition's Versioning Machine interface via a cron job that runs once a minute. The cron job performs a git pull, runs the transformations via a shell script, uploads the html files to the site directory, and deletes the temp files created in the process.