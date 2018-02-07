# Sonatype-Nexus-temporaryfile-Publisher
A small shell script to help you push temporary files to your Nexus Server.

## Requirements:
- A Sonatype Nexus Server.
- mvn
- curl

## Setting up your Nexus
- Create a new Maven2 Repo with an appropiate name and Allow Re-Deploys (e.g. temp)
- Create a Scheduled task that removes releases from a repository to clean up the uploaded files. (e.g. Daily)
<aside class="notice">Note: the scheduled task will not delete raw uploads which where uploaded in curl mode. You can use the -d flag of this tool to help you delete it. (Or just use the web interface)</aside>

<aside class="warning">
Protip: Be sure to create a username and password combo that are used specific for this repo, to isolate and prevent security leaks ( e.g. Prevent leaking a script that uses a user with elevated rights over other repos as the temp repo OR leaving traces of an elevated username/password on a machine where you download the temporary files, leaving your nexus vurnable for outsiders.)
 </aside>

## Configure the script
Configure the variables in the script to fit your needs (e.g. nexus url etc.)

## Usage
you can use this tool with Maven (which will publish some additional md5 hashes) or curl (raw upload paths).

tool < Nexus Username > < Nexus Password > < Path to file to be uploaded > < artifact name > < -c curl flag | -d delete curl flag >
Append -c at the end to force the tool to use curl instead of Maven.
Append -d at the end to force the tool to make curl delete a file (you published with -c)

### Example: Uploading a file in Maven Mode;
publish.sh username password ~/Downloads/developer-calls-it-done-meme.png test

### Example: Uploading a file in Curl Mode;
publish.sh username password ~/Downloads/developer-calls-it-done-meme.png test -c

### Example: Deleting a file in Maven Mode;
publish.sh username password ~/Downloads/developer-calls-it-done-meme.png test -d
