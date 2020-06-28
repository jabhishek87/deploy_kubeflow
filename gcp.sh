#!/bin/bash
. ./functions.sh
. ./gcp.env

version() {
    echo "gcp v0.0.1"
}
usage() {
    printf "Usage " + STAR
    printf "$(basename "$0") [-h, v] [-s n] \n

    where
    -h show this help text
    -v version
    -r run commands
    Valid run commands are:
        gcp_check_prerequisites:        check if all dependencies resolved
        create_project <PROJECT_NAME>   create a new project
        generate_config                 generate config o use
        gcp_run_default_login           gcp default login
        deploy_kubeflow                 create gke cluster and install kubeflow

    "
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while getopts ':hr:v' option; do
  case "$option" in
    h) usage
       exit
       ;;
    r) shift 2
        $OPTARG $@
        # echo $OPTARG $@
       ;;
    v) version
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))


# option="${1}"
# case ${option} in
#    -f) FILE="${2}"
#       echo "File name is $FILE"
#       ;;
#    -d) DIR="${2}"
#       echo "Dir name is $DIR"
#       ;;
#    *)
#       echo "`basename ${0}`:usage: [-f file] | [-d directory]"
#       exit 1 # Command to come out of the program with status 1
#       ;;
# esac