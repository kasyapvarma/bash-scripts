# bash-scripts
Bash scripts for various purposes

# copy-oldest-files.sh
Given a source directory and destination directory(if empty), copies the files from source directory to desination directory which are from oldest t hours in source directory. It is also assumed that the script is executed for every 30 seconds so script timeouts if the destination directory is not empty for 25 seconds.
<br /><br />
 usage
  <br /><br />
./copy-oldest-files.sh t 
  <br /><br />
  arguments - "t" in hours

