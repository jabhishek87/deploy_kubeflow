#!/bin/bash
STAR="****************************************"

gcp_check_prerequisites(){ # sdfsfskd
     # docs
    is_dependency_install gcloud1
    is_dependency_install kfctl
}

gcp_run_default_login(){
    gcloud auth application-default login
}

create_project(){
    if [ $# -eq 0 ]; then
        # echo "./gcp.sh create_project <PROJECT_NAME>"
        printf "$(basename ) create_project <PROJECT_NAME>"
    else
        echo "Creating Project ${STAR}"
        prj_id="${1}-$$$RANDOM"
        echo "gcloud projects create ${prj_id} --name '${1}' --set-as-default"
        gcloud projects create ${prj_id} --name '${1}' --set-as-default
    fi
}
enable_billing(){
    PROJECT_ID=$(gcloud config list project --format "value(core.project)")
    . config.env
    gcloud alpha billing projects link $PROJECT_ID --billing-account $biiling_id
}

enable_services(){
    gcloud services enable compute.googleapis.com container.googleapis.com \
    iam.googleapis.com deploymentmanager.googleapis.com \
    cloudresourcemanager.googleapis.com file.googleapis.com \
    ml.googleapis.com cloudbuild.googleapis.com
}

deploy_kubeflow(){
    # create current dir as working Dir
    export PROJECT_ID=$(gcloud config list project --format "value(core.project)")
    echo "PROJECT_ID = $PROJECT_ID"

    echo "ZONE of your kubeflow deployment is $zone"
    export ZONE=$zone

    echo "your CLIENT_ID is $client_id"
    export CLIENT_ID=$client_id

    echo "your CLIENT_SECRET is $client_secret"
    export CLIENT_SECRET=$client_secret

    export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.0-branch/kfdef/kfctl_gcp_iap.v1.0.2.yaml"

    echo "The name for the Kubeflow deployment is $name"
    export KF_NAME=$name
    # kf_dir="${KF_NAME}-$$$RANDOM"
    export KF_DIR="`pwd`/${KF_NAME}"
    # echo "KF_DIR = $KF_DIR"
    mkdir -p ${KF_DIR}
    pushd ${KF_DIR}

    kfctl build -V -f ${CONFIG_URI}
    export CONFIG_FILE=${KF_DIR}/kfctl_gcp_iap.v1.0.2.yaml
    kfctl apply -V -f ${CONFIG_FILE}
    # echo "pushd `pwd`"
    popd
    # echo "popd `pwd`"
}

wait_for_service_to_come_up(){
    for i in {30..01}; do
        echo -en "waithin service to come up ${i}m\n"
        sleep 30
    done
        echo
}


generate_config(){
    zone=us-central1-a
    echo "Disclaimer Everything in gc.env is going be overwritten"
    cp gcp.env gcp.env-$$$RANDOM
    echo "Generating  Config ${STAR}"

    echo -n "Enter Cluster Name> "
    read cluster_name
    check_empty ${cluster_name}
    echo "${cluster_name}"

    echo -n "\nEnter biling id get it from here https://console.cloud.google.com/billing > "
    read biiling_id
    check_empty ${biiling_id}
    echo "${biiling_id}"

    echo -n "\nEnter client_id id get it from here https://console.cloud.google.com/apis/credentials > "
    read client_id
    check_empty ${client_id}
    echo "${client_id}"

    echo -n "\nEnter client_secret id > "
    read client_secret
    check_empty ${client_secret}
    echo "${client_secret}"

    content="zone=${zone}\nname=${cluster_name}\nbiiling_id=${biiling_id} \
        \nclient_id=${client_id}\nclient_secret=${client_secret}\n"
    echo -en "${content}" > gcp.env


}
check_empty(){
    # [ -z "$1" ] && echo "Cannot be EMPTY"  exit 1
    if [ -z "$1" ]
    then
        echo "Cannot be EMPTY"
        exit 1
    fi
}
is_dependency_install(){
    package=$1
    type ${package} >/dev/null 2>&1 || {
        echo >&2 "${package} is not installed. ${package} is required to proceed"
        echo >&2 "visit: http://www.google.com/search?q=install+${package}"
    }
}