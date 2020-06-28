# deploy_kubeflow
deploy_kubeflow


### Disclaimer
This is a demo project to deploy kubeflow to gcp , it cannot be used for production


### Deployment
Kubeflow deployment has 3 main settings
- [Setting of prerequisites for Kube flow GKE cluster](#prerequisites)
- [Assuming you have everything in ready and you want to spinup a new GKE cluster](#launch-cluster)
- [setting up everything from scratch](#setup-scratch)

### <a id="prerequisites"></a> prerequisites

#### Step: 1
- Run `touch gcp.env`
- Check prerequisites `./gcp.sh -r gcp_check_prerequisites`

#### Step: 2
- Run gcloud auth login
- `./gcp.sh -r gcp_run_default_login` OR `gcloud auth application-default login`

#### step3: Set Default project
- `gcloud config set project <PROJECT-ID>`
- to get project list run `gcloud projects list`

#### Step: 4
- Create config file by running interactive command
- `./gcp.sh -r generate_config` OR
- updating below value in gcp.env
```sh
zone=<Enter your preffered zone for your Kubeflow deployment>
client_id=<Enter the CLIENT_ID from OAuth page>
client_secret=<Enter the CLIENT_SECRET from OAuth page>
name=<Enter the name for your Kubeflow deployment>
biiling_id=<GCP Account number>
```

### <a id="launch-cluster"></a> Launch Gke Cluster and install Kubeflow
- `./gcp.sh -r deploy_kubeflow`

### <a id="setup-scratch"></a> Setup every thing from scratch
#### Step: 1 Create new Project
- `./gcp.sh -r create_project <PROJECT_NAME>`

#### Step: 2 Set up OAuth for Cloud IAP
- https://www.kubeflow.org/docs/gke/deploy/oauth-setup/
- keep client_id and client_secret handy

#### Step: 3 Create Config
- Create config file by running interactive command
- `./gcp.sh -r generate_config` OR
- updating below value in gcp.env
```sh
zone=<Enter your preffered zone for your Kubeflow deployment>
client_id=<Enter the CLIENT_ID from OAuth page>
client_secret=<Enter the CLIENT_SECRET from OAuth page>
name=<Enter the name for your Kubeflow deployment>
biiling_id=<GCP Account number>
```

### Step: 4 Enable billing
-- `./gcp.sh -r enable_billing `

### Step: 5 Enable Required Services
-- `./gcp.sh -r enable_services `

### Step: 6 Deploy Kubeflow over GKE Cluster
- `./gcp.sh -r deploy_kubeflow`
