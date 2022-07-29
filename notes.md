Summary:
1 mgmt cluster only (hybrid)
- Since Gloo Mesh and the Gloo Mesh Agent are in the same cluster, we can configure both to communicate over ClusterIP
gloo mesh 2.0.9
istio 1.13.4 with revisions
north/south gateway only

mgmt ingress exposing:

argocd at on port 443 at /argo
host: argocd.kapoozi.com
- this endpoint is protected by okta
- user will still need to basic auth after okta as well

gloo mesh on port 443 
host: gmui-local.kapoozi.com
- this endpoint is protected by OIDC + Google auth integration

httpbin on 443 with the prefix /anything/unprotected
host: httpbin.kapoozi.com
- this route is publicly available
- this route is rate limited at 20 req/min

httpbin on 443 with the prefix /get and /anything/protected
host: httpbin.kapoozi.com
- this endpoint is protected by okta
- this route is rate limited at 20 req/min
- this route has OPA policy attached
    - users with @solo.io can access path /get and path with prefix /anything
    - users with @gmail.com can only access exact path /anything/protected
- JWTPolicy enabled - extracts x-email and x-organization claims to headers
- Transformation policy extracts the x-organization header from x-email header using regex

grafana on port 443 at /grafana
host: grafana.kapoozi.com
- this endpoint is protected by okta
- istio and gloo mesh operations dashboards configured (see /tools/dashboards for json output)

bookinfo on 443 at /productpage
host: bookinfo.kapoozi.com
- this route has no limits
- log4j WAF policy enabled on this route

# collaboration tools
Collaboration tools workspace has the following apps

ghost blog on 443 at /
host: ghost.kapoozi.com
- this route is publicly available
- this route is rate limited at 40 req/min
- the admin page at the /ghost endpoint is protected by okta
- storage persisted with pvc using external civo-storage storageclass

plants blog on 443 at /
host: plants.kapoozi.com
- this route is publicly available
- the admin page at the /ghost endpoint is protected by basic auth
- storage persisted with pvc using internal longhorn storageclass

drawio on 443 at /
host: drawio.kapoozi.com

etherpad on 443 at /
host: etherpad.kapoozi.com
- storage persisted with pvc using internal longhorn storageclass