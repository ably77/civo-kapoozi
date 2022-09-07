# gloo-mesh-demo-aoa

## version 2.1.0-beta24
This repo provides a multitenant capable GitOps workflow structure that can be forked and used to demonstrate the deployment and configuration of a multi-cluster mesh demo as code using the Argo CD app-of-apps pattern.

# Prerequisites 
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance for `mgmt` cluster

# High Level Architecture
![High Level Architecture](images/aoa-1a.png)

# Getting Started
Run:
```
./deploy.sh $LICENSE_KEY $cluster_context        # deploys on mgmt cluster by default if no input
```
The script will prompt you for a Gloo Mesh Enterprise license key if not provided as an input parameter

Note:
- By default, the script will deploy into a cluster context named `mgmt`if not passed in
- Context parameters can be changed from defaults by passing in variables in the `deploy.sh` A check is done to ensure that the defined contexts exist before proceeding with the installation. Note that the character `_` is an invalid value if you are replacing default contexts
- Although you may change the contexts where apps are deployed as describe above, the Gloo Mesh and Istio cluster names will remain stable references (i.e. `mgmt`, `cluster1`, and `cluster2`)

# App of Apps Explained
The app-of-apps pattern uses a generic Argo Application to sync all manifests in a particular Git directory, rather than directly point to a Kustomize, YAML, or Helm configuration. Anything pushed into the `environment/<overlay>/active` directory is deployed by it's corresponding app-of-app
```
environment
├── wave-1
│   ├── active
│   │   ├── argocd-ns.yaml
│   │   ├── argocd-okta-client-secret.yaml
│   │   ├── bank-demo-jwt-secret.yaml
│   │   ├── bank-demo-ns.yaml
│   │   ├── bookinfo-backends-ns.yaml
│   │   ├── bookinfo-frontends-ns.yaml
│   │   ├── bookinfo-okta-client-secret.yaml
│   │   ├── cert-manager-cacerts.yaml
│   │   ├── cert-manager-ns.yaml
│   │   ├── collaboration-tools-ns.yaml
│   │   ├── ghost-blog-pvc.yaml
│   │   ├── ghost-okta-client-secret.yaml
│   │   ├── gloo-mesh-addons-ns.yaml
│   │   ├── gloo-mesh-ns.yaml
│   │   ├── gloo-mesh-relay-identity-token-secret.yaml
│   │   ├── gloo-mesh-relay-root-ca.yaml
│   │   ├── grafana-okta-client-secret.yaml
│   │   ├── homer-okta-client-secret.yaml
│   │   ├── httpbin-ns.yaml
│   │   ├── httpbin-okta-client-secret.yaml
│   │   ├── istio-gateways-ns.yaml
│   │   ├── istio-system-ns.yaml
│   │   └── web-portal-ns.yaml
│   ├── init.sh
│   ├── test.sh
│   └── wave-1-aoa.yaml
├── wave-10
│   ├── active
│   │   ├── collaboration-workspace.yaml
│   │   ├── collaboration-workspacesettings.yaml
│   │   ├── drawio-rt-443.yaml
│   │   ├── drawio.yaml
│   │   ├── etherdraw-rt-443.yaml
│   │   ├── etherdraw.yaml
│   │   ├── etherpad-rt-443.yaml
│   │   ├── etherpad.yaml
│   │   ├── ghost-blog-extauth-policy-443.yaml
│   │   ├── ghost-blog-rt-443.yaml
│   │   ├── ghost-blog.yaml
│   │   ├── ghost-ratelimit-transformationfilter.yaml
│   │   ├── ghost-ratelimitclientconfig.yaml
│   │   ├── ghost-ratelimitpolicy.yaml
│   │   ├── ghost-ratelimitserverconfig.yaml
│   │   ├── ghost-ratelimitserversettings.yaml
│   │   ├── plants-blog-rt-443.yaml
│   │   └── plants-blog.yaml
│   ├── init.sh
│   ├── test.sh
│   └── wave-10-aoa.yaml
├── wave-2
│   ├── active
│   │   └── cert-manager.yaml
│   ├── init.sh
│   ├── test.sh
│   └── wave-2-aoa.yaml
├── wave-3
│   ├── active
│   │   ├── gateway-cert.yaml
│   │   ├── grafana.yaml
│   │   ├── istio-base.yaml
│   │   ├── istio-ingressgateway.yaml
│   │   ├── istiod-1-13.yaml
│   │   ├── kiali.yaml
│   │   └── prometheus.yaml
│   ├── init.sh
│   ├── test.sh
│   └── wave-3-aoa.yaml
├── wave-4
│   ├── active
│   │   ├── cert-manager-clusterissuer.yaml
│   │   ├── cert-manager-issuer.yaml
│   │   ├── gloo-mesh-cert.yaml
│   │   ├── gloo-mesh-ee-helm-disableca.yaml
│   │   └── gloo-mesh-relay-tls-signing-cert.yaml
│   ├── init.sh
│   ├── test.sh
│   └── wave-4-aoa.yaml
├── wave-5
│   ├── active
│   │   ├── gloo-mesh-addons.yaml
│   │   ├── gloo-mesh-agent-cert.yaml
│   │   └── gloo-mesh-agent.yaml
│   ├── init.sh
│   ├── test.sh
│   └── wave-5-aoa.yaml
├── wave-6
│   ├── active
│   │   ├── argocd-cluster1-rt-443.yaml
│   │   ├── argocd-extauth-policy.yaml
│   │   ├── argocd-mgmt-rt-443.yaml
│   │   ├── gloo-mesh-admin-workspace.yaml
│   │   ├── gloo-mesh-admin-workspacesettings.yaml
│   │   ├── gloo-mesh-cluster1-kubernetescluster.yaml
│   │   ├── gloo-mesh-cluster1-virtualgateway-443.yaml
│   │   ├── gloo-mesh-cluster1-virtualgateway-80.yaml
│   │   ├── gloo-mesh-gateways-workspace.yaml
│   │   ├── gloo-mesh-gateways-workspacesettings.yaml
│   │   ├── gloo-mesh-global-workspacesettings.yaml
│   │   ├── gloo-mesh-mgmt-extauth-server.yaml
│   │   ├── gloo-mesh-mgmt-kubernetescluster.yaml
│   │   ├── gloo-mesh-mgmt-virtualgateway-443.yaml
│   │   ├── gloo-mesh-mgmt-virtualgateway-80.yaml
│   │   ├── gloo-mesh-ui-rt-443.yaml
│   │   ├── grafana-extauth-policy.yaml
│   │   ├── grafana-rt-443.yaml
│   │   ├── homer-portal.yaml
│   │   └── homer-rt-443.yaml
│   ├── init.sh
│   ├── test.sh
│   └── wave-6-aoa.yaml
├── wave-7
│   ├── active
│   │   ├── bookinfo-backends-dyaml.yaml
│   │   ├── bookinfo-extauth-policy.yaml
│   │   ├── bookinfo-frontends-dyaml.yaml
│   │   ├── bookinfo-oauth-rt-443.yaml
│   │   ├── bookinfo-ratelimit-transformationfilter.yaml
│   │   ├── bookinfo-ratelimitclientconfig.yaml
│   │   ├── bookinfo-ratelimitpolicy.yaml
│   │   ├── bookinfo-ratelimitserverconfig.yaml
│   │   ├── bookinfo-ratelimitserversettings.yaml
│   │   ├── bookinfo-wafpolicy-log4shell.yaml
│   │   ├── bookinfo-workspace.yaml
│   │   └── bookinfo-workspacesettings.yaml
│   ├── init.sh
│   ├── test.sh
│   └── wave-7-aoa.yaml
├── wave-8
│   ├── active
│   │   ├── httpbin-extauth-policy.yaml
│   │   ├── httpbin-in-mesh.yaml
│   │   ├── httpbin-jwt-transformationpolicy.yaml
│   │   ├── httpbin-jwtpolicy.yaml
│   │   ├── httpbin-not-in-mesh.yaml
│   │   ├── httpbin-oauth-rt-443.yaml
│   │   ├── httpbin-okta-jwks-externalendpoint.yaml
│   │   ├── httpbin-okta-jwks-externalservice.yaml
│   │   ├── httpbin-ratelimit-transformationpolicy.yaml
│   │   ├── httpbin-ratelimitclientconfig.yaml
│   │   ├── httpbin-ratelimitpolicy.yaml
│   │   ├── httpbin-ratelimitserverconfig.yaml
│   │   ├── httpbin-ratelimitserversettings.yaml
│   │   ├── httpbin-wafpolicy-log4shell.yaml
│   │   ├── httpbin-workspace.yaml
│   │   └── httpbin-workspacesettings.yaml
│   ├── init.sh
│   ├── test.sh
│   └── wave-8-aoa.yaml
└── wave-9
    ├── active
    │   ├── bank-accounts-db.yaml
    │   ├── bank-balance-reader.yaml
    │   ├── bank-config.yaml
    │   ├── bank-contacts.yaml
    │   ├── bank-demo-rt-443.yaml
    │   ├── bank-demo-workspace.yaml
    │   ├── bank-demo-workspacesettings.yaml
    │   ├── bank-frontend.yaml
    │   ├── bank-ledger-db.yaml
    │   ├── bank-ledger-writer.yaml
    │   ├── bank-transaction-history.yaml
    │   └── bank-userservice.yaml
    ├── init.sh
    ├── test.sh
    └── wave-9-aoa.yaml
```

# forking this repo
Fork this repo and run the script below to your GitHub username if owning the control over pushing/pulling into the repo is desirable
```
cd tools/
./replace-github-username.sh <current_username> <desired_username>
```
Now you can push new manifests into the corresponding `environments` directories in your fork to sync them using Argo CD
