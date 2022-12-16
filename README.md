# gloo-mesh-demo-aoa
This repo provides a multitenant capable GitOps workflow structure that can be forked and used to demonstrate the deployment and configuration of a multi-cluster mesh demo as code using the Argo CD app-of-apps pattern.

# versions
- base:
    - gloo mesh 2.1.2
    - istio 1.13.4
    - revision: 1-13
- prod:
    - gloo mesh 2.1.2
    - istio 1.13.4
    - revision: 1-13
- dev:
    - gloo mesh 2.1.2
    - istio 1.13.4
    - revision: 1-13

This repo is meant to be deployed along with the following repos to create the entire High Level Architecture diagram below.
- https://github.com/ably77/civo-kapoozi-c1
- https://github.com/ably77/civo-kapoozi-c2

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
% tree environment 
environment
├── 1-clusterconfig
│   ├── base
│   │   └── active
│   │       ├── argocd-ns.yaml
│   │       ├── argocd-okta-client-secret.yaml
│   │       ├── bank-demo-jwt-secret.yaml
│   │       ├── bank-demo-ns.yaml
│   │       ├── bookinfo-backends-ns.yaml
│   │       ├── bookinfo-frontends-ns.yaml
│   │       ├── bookinfo-okta-client-secret.yaml
│   │       ├── collaboration-tools-ns.yaml
│   │       ├── ghost-blog-pvc.yaml
│   │       ├── ghost-okta-client-secret.yaml
│   │       ├── gloo-mesh-addons-ns.yaml
│   │       ├── gloo-mesh-ns.yaml
│   │       ├── gloo-mesh-relay-identity-token-secret.yaml
│   │       ├── gloo-mesh-relay-root-ca.yaml
│   │       ├── grafana-okta-client-secret.yaml
│   │       ├── homer-okta-client-secret.yaml
│   │       ├── httpbin-ns.yaml
│   │       ├── httpbin-okta-client-secret.yaml
│   │       ├── istio-gateways-ns.yaml
│   │       ├── istio-system-ns.yaml
│   │       ├── kustomization.yaml
│   │       ├── ops-team-config-ns.yaml
│   │       ├── ops-team-okta-client-secret.yaml
│   │       ├── supermario-ns.yaml
│   │       └── web-portal-ns.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 10-games-app
│   ├── base
│   │   └── active
│   │       ├── kustomization.yaml
│   │       └── supermario.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 10-games-config
│   ├── base
│   │   └── active
│   │       ├── games-workspace.yaml
│   │       ├── games-workspacesettings.yaml
│   │       ├── kustomization.yaml
│   │       └── supermario-rt-443.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 11-solowallet-app
│   ├── base
│   │   └── active
│   │       ├── bank-accounts-db.yaml
│   │       ├── bank-balance-reader.yaml
│   │       ├── bank-config.yaml
│   │       ├── bank-contacts.yaml
│   │       ├── bank-frontend.yaml
│   │       ├── bank-ledger-db.yaml
│   │       ├── bank-ledger-writer.yaml
│   │       ├── bank-transaction-history.yaml
│   │       ├── bank-userservice.yaml
│   │       └── kustomization.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 11-solowallet-config
│   ├── base
│   │   └── active
│   │       ├── bank-demo-rt-443.yaml
│   │       ├── bank-demo-workspace.yaml
│   │       ├── bank-demo-workspacesettings.yaml
│   │       └── kustomization.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 12-numaflow-config
│   ├── base
│   │   └── active
│   │       ├── kustomization.yaml
│   │       ├── numaflow-config-ns.yaml
│   │       ├── numaflow-rt-443.yaml
│   │       ├── numaflow-workspace.yaml
│   │       └── numaflow-workspacesettings.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 13-online-boutique-app
│   ├── base
│   │   └── active
│   │       ├── backend-apis-ns.yaml
│   │       ├── backend-apis.yaml
│   │       ├── kustomization.yaml
│   │       ├── web-ui-ns.yaml
│   │       ├── web-ui-v2.yaml
│   │       └── web-ui.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 13-online-boutique-config
│   ├── base
│   │   └── active
│   │       ├── allownothing-accesspolicy.yaml
│   │       ├── backend-apis-team-workspace.yaml
│   │       ├── backend-apis-team-workspacesettings.yaml
│   │       ├── failoverpolicy.yaml
│   │       ├── frontend-api-accesspolicy.yaml
│   │       ├── frontend-mirrorpolicy.yaml
│   │       ├── in-namespace-accesspolicy.yaml
│   │       ├── kustomization.yaml
│   │       ├── outlierdetectionpolicy.yaml
│   │       ├── vd.yaml
│   │       ├── web-team-workspace.yaml
│   │       ├── web-team-workspacesettings.yaml
│   │       ├── web-ui-extauth-policy.yaml
│   │       ├── web-ui-okta-client-secret.yaml
│   │       └── web-ui-rt-443.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 14-plex-config
│   ├── base
│   │   └── active
│   │       ├── kustomization.yaml
│   │       ├── plex-config-ns.yaml
│   │       ├── plex-rt-443.yaml
│   │       ├── plex-workspace.yaml
│   │       └── plex-workspacesettings.yaml
│   ├── dev
│   │   └── active
│   │       ├── kustomization.yaml
│   │       ├── patch
│   │       │   └── plex-rt-443.yaml
│   │       └── vd.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 2-certmanager
│   ├── base
│   │   └── active
│   │       ├── cert-manager-cacerts.yaml
│   │       ├── cert-manager.yaml
│   │       └── kustomization.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 3-istio
│   ├── base
│   │   └── active
│   │       ├── certmanager-istio-ca-cert.yaml
│   │       ├── certmanager-selfsigned-issuer.yaml
│   │       ├── gateway-cert.yaml
│   │       ├── grafana.yaml
│   │       ├── istio-base.yaml
│   │       ├── istio-eastwestgateway.yaml
│   │       ├── istio-ingressgateway.yaml
│   │       ├── istiod-1-13.yaml
│   │       ├── kiali.yaml
│   │       ├── kustomization.yaml
│   │       └── prometheus.yaml
│   ├── dev
│   │   ├── active
│   │   │   └── kustomization.yaml
│   │   └── non-active
│   │       ├── istio-eastwestgateway.yaml
│   │       └── jaeger.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 4-gloo-mesh
│   ├── base
│   │   └── active
│   │       ├── cert-manager-clusterissuer.yaml
│   │       ├── cert-manager-issuer.yaml
│   │       ├── gloo-mesh-cert.yaml
│   │       ├── gloo-mesh-crds.yaml
│   │       ├── gloo-mesh-ee-helm-disableca.yaml
│   │       ├── gloo-mesh-relay-tls-signing-cert.yaml
│   │       └── kustomization.yaml
│   ├── dev
│   │   └── active
│   │       ├── kustomization.yaml
│   │       └── patches
│   │           ├── gloo-mesh-crds.yaml
│   │           └── gloo-mesh-ee-helm-disableca.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 5-gloo-mesh-agent
│   ├── base
│   │   └── active
│   │       ├── gloo-mesh-addons.yaml
│   │       ├── gloo-mesh-agent-cert.yaml
│   │       ├── gloo-mesh-agent.yaml
│   │       └── kustomization.yaml
│   ├── dev
│   │   └── active
│   │       ├── kustomization.yaml
│   │       └── patches
│   │           ├── gloo-mesh-addons.yaml
│   │           └── gloo-mesh-agent.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 6-gloo-mesh-config
│   ├── base
│   │   └── active
│   │       ├── argocd-cluster1-rt-443.yaml
│   │       ├── argocd-extauth-policy.yaml
│   │       ├── argocd-mgmt-rt-443.yaml
│   │       ├── gloo-mesh-cluster1-kubernetescluster.yaml
│   │       ├── gloo-mesh-cluster1-virtualgateway-443.yaml
│   │       ├── gloo-mesh-cluster1-virtualgateway-80.yaml
│   │       ├── gloo-mesh-global-workspacesettings.yaml
│   │       ├── gloo-mesh-mgmt-extauth-server.yaml
│   │       ├── gloo-mesh-mgmt-kubernetescluster.yaml
│   │       ├── gloo-mesh-mgmt-virtualgateway-443.yaml
│   │       ├── gloo-mesh-mgmt-virtualgateway-80.yaml
│   │       ├── gloo-mesh-ops-team-workspace.yaml
│   │       ├── gloo-mesh-ops-team-workspacesettings.yaml
│   │       ├── gloo-mesh-ui-rt-443.yaml
│   │       ├── grafana-extauth-policy.yaml
│   │       ├── grafana-rt-443.yaml
│   │       ├── kustomization.yaml
│   │       ├── longhorn-extauth-policy.yaml
│   │       ├── longhorn-rt-443.yaml
│   │       ├── roottrustpolicy-secretref.yaml
│   │       └── uptime-cluster1-rt-443.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   ├── active
│   │   │   └── kustomization.yaml
│   │   └── non-active
│   │       ├── gm-ui-rt-vd-443.yaml
│   │       ├── grafana-rt-80.yaml
│   │       ├── homer-rt-80.yaml
│   │       ├── kubernetescluster-cluster1.yaml
│   │       ├── roottrustpolicy-secretref.yaml
│   │       ├── roottrustpolicy.yaml
│   │       └── uptime-extauth-policy.yaml
│   └── test.sh
├── 7-bookinfo-app
│   ├── base
│   │   └── active
│   │       ├── bookinfo-backends-dyaml.yaml
│   │       ├── bookinfo-frontends-dyaml.yaml
│   │       └── kustomization.yaml
│   ├── dev
│   │   ├── active
│   │   │   └── kustomization.yaml
│   │   └── non-active
│   │       ├── bombardier.yaml
│   │       ├── bookinfo-cert.yaml
│   │       ├── bookinfo-rt-80.yaml
│   │       └── productpage-cluster1-rt-443.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 7-bookinfo-config
│   ├── base
│   │   ├── active
│   │   │   ├── bookinfo-extauth-policy.yaml
│   │   │   ├── bookinfo-oauth-rt-443.yaml
│   │   │   ├── bookinfo-ratelimit-transformationfilter.yaml
│   │   │   ├── bookinfo-ratelimitclientconfig.yaml
│   │   │   ├── bookinfo-ratelimitpolicy.yaml
│   │   │   ├── bookinfo-ratelimitserverconfig.yaml
│   │   │   ├── bookinfo-ratelimitserversettings.yaml
│   │   │   ├── bookinfo-wafpolicy-log4shell.yaml
│   │   │   ├── bookinfo-workspace.yaml
│   │   │   ├── bookinfo-workspacesettings.yaml
│   │   │   ├── kustomization.yaml
│   │   │   ├── plow-loadgen-argo.yaml
│   │   │   └── productpage-accesspolicy.yaml
│   │   └── non-active
│   ├── dev
│   │   ├── active
│   │   │   ├── bookinfo-failoverpolicy.yaml
│   │   │   ├── bookinfo-outlierdetectionpolicy.yaml
│   │   │   ├── kustomization.yaml
│   │   │   ├── patches
│   │   │   │   └── bookinfo-oauth-failover-rt-443.yaml
│   │   │   └── productpage-virtualdestination-443.yaml
│   │   └── non-active
│   │       ├── bombardier.yaml
│   │       ├── bookinfo-cert.yaml
│   │       ├── bookinfo-rt-80.yaml
│   │       └── productpage-cluster1-rt-443.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       ├── kustomization.yaml
│   │       └── patches
│   │           └── bookinfo-oauth-rt-443.yaml
│   └── test.sh
├── 8-httpbin-app
│   ├── base
│   │   └── active
│   │       ├── httpbin-in-mesh.yaml
│   │       ├── httpbin-not-in-mesh.yaml
│   │       └── kustomization.yaml
│   ├── dev
│   │   ├── active
│   │   │   └── kustomization.yaml
│   │   └── non-active
│   │       ├── bombardier.yaml
│   │       └── httpbin-rt-80.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 8-httpbin-config
│   ├── base
│   │   └── active
│   │       ├── httpbin-accesspolicy.yaml
│   │       ├── httpbin-extauth-policy.yaml
│   │       ├── httpbin-jwt-transformationpolicy.yaml
│   │       ├── httpbin-jwtpolicy.yaml
│   │       ├── httpbin-oauth-rt-443.yaml
│   │       ├── httpbin-okta-jwks-externalendpoint.yaml
│   │       ├── httpbin-okta-jwks-externalservice.yaml
│   │       ├── httpbin-opa-policy.yaml
│   │       ├── httpbin-ratelimit-transformationpolicy.yaml
│   │       ├── httpbin-ratelimitclientconfig.yaml
│   │       ├── httpbin-ratelimitpolicy.yaml
│   │       ├── httpbin-ratelimitserverconfig.yaml
│   │       ├── httpbin-ratelimitserversettings.yaml
│   │       ├── httpbin-rt-443-cluster1.yaml
│   │       ├── httpbin-wafpolicy-log4shell.yaml
│   │       ├── httpbin-workspace.yaml
│   │       ├── httpbin-workspacesettings.yaml
│   │       ├── kustomization.yaml
│   │       └── plow-loadgen-argo.yaml
│   ├── dev
│   │   ├── active
│   │   │   ├── httpbin-user-agent-waf.yaml
│   │   │   └── kustomization.yaml
│   │   └── non-active
│   │       ├── bombardier.yaml
│   │       └── httpbin-rt-80.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
├── 9-collaboration-tools-app
│   ├── base
│   │   ├── active
│   │   │   ├── drawio.yaml
│   │   │   ├── etherdraw.yaml
│   │   │   ├── etherpad.yaml
│   │   │   ├── ghost-blog.yaml
│   │   │   ├── homer-portal.yaml
│   │   │   ├── kustomization.yaml
│   │   │   └── plants-blog.yaml
│   │   └── non-active
│   │       └── bombardier-plantsblog.yaml
│   ├── dev
│   │   └── active
│   │       └── kustomization.yaml
│   ├── init.sh
│   ├── prod
│   │   └── active
│   │       └── kustomization.yaml
│   └── test.sh
└── 9-collaboration-tools-config
    ├── base
    │   ├── active
    │   │   ├── collaboration-workspace.yaml
    │   │   ├── collaboration-workspacesettings.yaml
    │   │   ├── drawio-rt-443.yaml
    │   │   ├── etherdraw-rt-443.yaml
    │   │   ├── etherpad-rt-443.yaml
    │   │   ├── ghost-admin-delegate-rt.yaml
    │   │   ├── ghost-blog-extauth-policy-443.yaml
    │   │   ├── ghost-main-delegate-rt.yaml
    │   │   ├── ghost-ratelimit-transformationfilter.yaml
    │   │   ├── ghost-ratelimitclientconfig.yaml
    │   │   ├── ghost-ratelimitpolicy.yaml
    │   │   ├── ghost-ratelimitserverconfig.yaml
    │   │   ├── ghost-ratelimitserversettings.yaml
    │   │   ├── ghost-root-rt.yaml
    │   │   ├── homer-rt-443.yaml
    │   │   ├── kustomization.yaml
    │   │   └── plants-blog-rt-443.yaml
    │   └── non-active
    │       └── ghost-blog-rt-443.yaml
    ├── dev
    │   └── active
    │       └── kustomization.yaml
    ├── init.sh
    ├── prod
    │   └── active
    │       └── kustomization.yaml
    └── test.sh
```

# forking this repo
Fork this repo and run the script below to your GitHub username if owning the control over pushing/pulling into the repo is desirable
```
cd tools/
./replace-github-username.sh <current_username> <desired_username>
```
Now you can push new manifests into the corresponding `environments` directories in your fork to sync them using Argo CD
