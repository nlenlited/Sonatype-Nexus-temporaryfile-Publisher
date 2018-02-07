#!/bin/sh
#
# Static variables
#
#export NEXUS_PORT=80
export NEXUS_REPO_URL=repository.yourcompany.com/content/repositories/
export NEXUS_REPO_NAME=temp
export NEXUS_REPO_GROUP=temporary
export ARTIFACT_VERSION=tmp
#
# Make the tool say hi if no arguments where given
#
if [ $# -eq 0 ]
  then
    echo "Simple Nexus Publisher Tool"
    echo "usage: tool <Nexus Username> <Nexus Password> <Path to file to be uploaded> <artifact name> <-c curl flag | -d delete curl flag>"
    echo "Append -c at the end to force the tool to use curl instead of Maven."
    echo "Append -d at the end to force the tool to make curl delete a file (you published with -c)"
    echo "Requires ; mvn and curl"
    exit 0
fi
#
#Check if Maven was installed
#
command -v mvn >/dev/null 2>&1 || { echo >&2 "I require mvn but it's not installed.  Aborting."; exit 1; }
#
#Check if Curl was installed
#
command -v curl >/dev/null 2>&1 || { echo >&2 "I require curl but it's not installed.  Aborting."; exit 1; }
#
# Read the Nexus username
#
export NEXUS_USER=$1
if [ -z "$1" ]
  then
    echo "No Nexus username specified"
    exit 1
fi
#
# Read the Nexus password
#
if [ -z "$2" ]
  then
    echo "No Nexus password specified"
    exit 1
fi
export NEXUS_PASSWORD=$2
#
# Read the File path of the file to be uploaded.
#
if [ -z "$3" ]
  then
    echo "No file path specified; please specify the file to be uploaded."
    exit 1
fi
export FILE_PATH=$3
#
# Read the Artifact name to be published
#
if [ -z "$4" ]
  then
    echo "No artifact name specified."
    exit 1
fi
export ARTIFACT_NAME=$4
#
# Read the tool to use
#
export TOOL="mvn"
if [ "$5" == "-c" ]; then 
    echo "Using curl as tool to publish"
    export TOOL="curl"
fi
if [ "$5" == "-d" ]; then 
    echo "Using curl as tool to delete a file"
    export TOOL="delcurl"
fi
#
# Use maven to deploy the file.
#
if [ "$TOOL" == "mvn" ]; then
  echo "Going to publish file $FILE_PATH to the nexus."
  mvn deploy:deploy-file -DgroupId=$NEXUS_REPO_GROUP -DartifactId=$ARTIFACT_NAME -Dversion=$ARTIFACT_VERSION -DgeneratePom=false -DrepositoryId=nexus -Durl=https://$NEXUS_USER:$NEXUS_PASSWORD@$NEXUS_REPO_URL$NEXUS_REPO_NAME -Dfile=$FILE_PATH
fi
if [ "$TOOL" == "curl" ]; then
  echo "Going to publish file $FILE_PATH to the nexus."
  extension="${FILE_PATH##*.}"
  curl -k -T $FILE_PATH -u $NEXUS_USER:$NEXUS_PASSWORD -v --url $NEXUS_REPO_URL$NEXUS_REPO_NAME/$ARTIFACT_NAME.$extension
  echo "URL to file: $NEXUS_REPO_URL$NEXUS_REPO_NAME/$ARTIFACT_NAME.$extension" 
fi
if [ "$TOOL" == "delcurl" ]; then
  echo "Going to DELETE file $ARTIFACT_NAME.$extension on the nexus."
  extension="${FILE_PATH##*.}"
  curl -v -X "DELETE" -u $NEXUS_USER:$NEXUS_PASSWORD --url $NEXUS_REPO_URL$NEXUS_REPO_NAME/$ARTIFACT_NAME.$extension
fi
