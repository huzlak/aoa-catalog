# Environment Description
The `gloo-gateway/backstage-bookinfo-httpbin` environment deploys the core components of a single cluster Gloo Platform demo, with the bookinfo deployed and exposed by Gloo Gateway

![High Level Architecture](.images/bookinfo-arch-1a.png)

### Prerequisites
- 1 Kubernetes Cluster
    - This demo has been tested on 1x `n2-standard-4` (gke), `m5.xlarge` (aws), or `Standard_DS3_v2` (azure) instance, and using K3d locally on M1 and Intel Macbook Pro
    - Kubernetes version 1.23-1.25

## Environment descriptions
- base:
    - gloo mesh 2.4.7
    - istio 1.19.3-solo (Helm)
    - revision: 1-19
- ilm:
    - gloo mesh 2.4.7
    - istio 1.19.3-solo (ILM)
    - revision: 1-19

## Application description

The RouteTables for applications exposed in this demo are defining non-wildcard hosts which follow the pattern `<app>.glootest.com`. You can map these hostnames to your gateway IP address in your DNS service of choice (i.e. Route53, Cloudflare), or you can follow the methods below to modify your `/etc/hosts` locally depending on your cluster LoadBalancer configuration.

Applications Exposed using this demo:
- Homer Link Dashboard at `https://localhost` or `https://<LB Address>`
- Grafana at `https://grafana.glootest.com`
- ArgoCD at `https://argocd.glootest.com/argo`
    - argocd credentials:
    - user: admin
    - password: solo.io
- Gloo Mesh UI at `https://gmui.glootest.com`
- Backstage at `https://backstage.glootest.com`
- Bookinfo at `https://bookinfo.glootest.com/productpage`
- httpbin at `https://httpbin.glootest.com/get` and `https://httpbin.glootest.com/anything`
- Homer link dashboard at `https://<GATEWAY_IP>` or `https://localhost` if using K3d integration

To access applications, follow the methods below:

#### Method 1 - LoadBalancer External-IP

Discover your gateway IP address
```
ISTIO_REVISION=1-19
GATEWAY_IP=$(kubectl -n istio-gateways get service istio-ingressgateway-${ISTIO_REVISION} -o jsonpath='{.status.loadBalancer.ingress[0].*}')

echo ${GATEWAY_IP}
```

Modify /etc/hosts on your local machine (this will require sudo privileges), or configure DNS to point to your Ingress Gateway IP
```
cat <<EOF | sudo tee -a /etc/hosts
${GATEWAY_IP} argocd.glootest.com gmui.glootest.com backstage.glootest.com bookinfo.glootest.com httpbin-local.glootest
EOF
```

#### Method 2 - K3d LB Integration
modify /etc/hosts on your local machine (this will require sudo privileges)
```
cat <<EOF | sudo tee -a /etc/hosts
127.0.0.1 argocd.glootest.com gmui.glootest.com backstage.glootest.com bookinfo.glootest.com httpbin-local.glootest
EOF
```

#### Method 3: use port-forwarding

To access argocd using port-forward command:
```
kubectl port-forward svc/argocd-server -n argocd 9999:443 --context <cluster_name>
```
access argocd at https://localhost:9999/argo



To access gloo mesh ui using port-forward command:
```
kubectl port-forward -n gloo-mesh svc/gloo-mesh-ui 8090 --context <cluster_name>
```
access gloo mesh ui at https://localhost:8090"



To access Istio Ingress Gateway using port-forward command:
```
ISTIO_REVISION=1-19
kubectl port-forward -n istio-gateways svc/istio-ingressgateway-${ISTIO_REVISION} 8443:443 --context <cluster_name>
```
access the ingress gateway at https://localhost:8443


Note: For routes that are configured with a specific host, pass in the Host header using curl `-H "Host: <host>` or add the following entry into your /etc/hosts when using this method
```
cat <<EOF | sudo tee -a /etc/hosts
127.0.0.1 argocd.glootest.com gmui.glootest.com backstage.glootest.com bookinfo.glootest.com httpbin-local.glootest
EOF
```