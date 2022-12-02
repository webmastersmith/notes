Helm Kubernetes Package Manager

- Kubernetes package manager

  - Kubernetes YAML manifests combined into a single package that can be
    advertised to your Kubernetes clusters.
  - simplifies the deployment of containerized applications.

install

- <https://helm.sh/docs/intro/install/>

start

Kubernetes must be running. I'm using minikube

workflow

helm repo add jenkins https://charts.jenkins.io

helm repo update

helm install \[RELEASE_NAME\] jenkins/jenkins \[flags\]

troubleshooting

- helm version

- helm repo update

- helm search repo jenkinsci

- helm search hub jenkinsci

- helm list -d //-d is default. can leave off.

- kubectl get svc -n nginx //show service routes

- kubectl get clusterrole \| grep ingress

  - for i in \$(kubectl get clusterrole \| grep ingress); do kubectl
    delete clusterrole \$i; done

- kubectl get clusterrolebinding \| grep ingress

  - for i in \$(kubectl get clusterrolebinding \| grep ingress); do
    kubectl delete \$i; done

    - clusterrolebinding was purpose left of delete command.

- k get CustomResourceDefinition -A

  - k get crd

    - for i in \$(k get crd \| awk '{print \$1}' \| sed '/NAME/d'); do
      kubectl delete crd \$i; done

<table>
<tbody>
<tr class="odd">
<td><p>#!/bin/bash<br />
<br />
set -euo pipefail<br />
<br />
for CRD in $(kubectl get crds -o=name | grep "${GROUP}")<br />
do<br />
kubectl label ${CRD} app.kubernetes.io/managed-by=Helm --overwrite<br />
kubectl annotate ${CRD} meta.helm.sh/release-name=${HELM_RELEASE}
--overwrite<br />
kubectl annotate ${CRD}
meta.helm.sh/release-namespace=${HELM_RELEASE_NAMESPACE}
--overwrite<br />
done</p>
<p>or generate name:</p>
<p>metadata:<br />
generateName: random-</p></td>
</tr>
</tbody>
</table>

Start

- helm install YOUR_CUSTOM_NAME FolderNameWithCharts //will look for the
  'values.yaml' file.
- helm install CUSTOM_NAME FolderName -f custom-values.yaml
- helm install CUSTOM_NAME FolderName --values
  ./dir/dir/custom-values.yaml

repos

- <https://helm.sh/blog/new-location-stable-incubator-charts/>

- <https://artifacthub.io/>

  - <https://artifacthub.io/packages/helm/jenkinsci/jenkins>

- <https://charts.helm.sh/stable>

  - helm repo add stable https://charts.helm.sh/stable --force-update
    //helm v3.4.0

- <https://charts.helm.sh/incubator>

add repo

- helm repo add bitnami <https://charts.bitnami.com/bitnami>
- helm repo add jenkins https://charts.jenkins.io

config

- helm show values jenkins/jenkins

install

- <https://helm.sh/docs/helm/helm_install/>

- helm install NAME FOLDER \[flags\] //custom folder

- helm install \[RELEASE_NAME\] jenkins/jenkins \[flags\]

- flags

  - -f \| --values //values file location.

search

- helm search repo bitnami //see all bitnami repository items
- helm search repo jenkins
- helm search repo bitnami \| grep something

show

- helm show values jenkinsci/jenkins \| **sed -e "/^\s\*\\#/d" \| sed -e
  "/^\$/d"** \> values.yaml //remove comments.

start

-

update

- helm repo update

uninstall

- helm uninstall \[RELEASE_NAME\]

upgrade

- allows you change items in 'values.yaml' file and update the cluster
  with them.
- helm upgrade \[RELEASE_NAME\] jenkins/jenkins \[flags\]

view

- helm show chart bitnami/mysql
- helm show all bitnami/mysql //show all
- helm show values bitnami/mysql

**nginx-stable/**nginx-ingress //from the nginx people open-source.
'nginx plus' is the paid version.

- <https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/>
-

<table>
<tbody>
<tr class="odd">
<td><p>helm repo add nginx-stable https://helm.nginx.com/stable</p>
<p>helm repo update</p>
<p>helm install my-release nginx-stable/nginx-ingress -n nginx # k apply
ingress.yaml //no namespace needed.</p></td>
</tr>
</tbody>
</table>

ingress-nginx //opensource

- <https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx>

- <https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx>

- <https://kubernetes.io/docs/concepts/services-networking/ingress/>

- <https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release>

- <https://towardsdatascience.com/how-to-set-up-ingress-controller-in-aws-eks-d745d9107307>

- namespace = default

- get values

  - helm show values ingress-nginx/ingress-nginx \>
    ingress-nginx/values.yaml

- install

  - k create ns nginx

  - helm upgrade --install ingress-nginx-chart
    ingress-nginx/ingress-nginx -n nginx

    - --install keeps error out if not running.

- get services

  - kubectl --namespace nginx get services -o wide -w
    ingress-nginx-chart-controller

  ingress

  - ingress is set to watch of 'ingressClass' of nginx. This can be
    changed.

<table>
<tbody>
<tr class="odd">
<td><p>helm repo add ingress-nginx
https://kubernetes.github.io/ingress-nginx</p>
<p>helm repo update</p>
<p>helm search repo nginx</p>
<p># already built into helm nginx</p>
<p>apiVersion: networking.k8s.io/v1</p>
<p>kind: IngressClass</p>
<p>metadata:</p>
<p> labels:</p>
<p> app.kubernetes.io/component: controller</p>
<p> name: nginx</p>
<p> annotations:</p>
<p> ingressclass.kubernetes.io/is-default-class: "true"</p>
<p>spec:</p>
<p> controller: k8s.io/ingress-nginx</p></td>
</tr>
</tbody>
</table>

jenkins

- <https://artifacthub.io/packages/helm/jenkinsci/jenkins>

- <https://github.com/jenkinsci/helm-charts/blob/main/charts/jenkins/VALUES_SUMMARY.md>

- <https://github.com/jenkinsci/helm-charts/blob/main/charts/jenkins/README.md>

- <https://github.com/jenkinsci/helm-charts/blob/main/charts/jenkins/ci/other-values.yaml>

- <https://plugins.jenkins.io/>

- get values

  - helm show values jenkinsci/jenkins \> jenkins/values.yaml

- namespace default

- get admin pw //username is 'admin'

  - kubectl exec --namespace jenkins -it svc/my-jenkins -c jenkins --
    /bin/cat /run/secrets/additional/chart-admin-password && echo

- logs

  - kubectl get pods -n jenkins
  - kubectl logs jenkins -n jenkins -f //-f stream logs

- port-forward

  - kubectl --namespace default port-forward svc/my-jenkins 8080:8080
  - & is background

- install

  - k create ns jenkins
  - helm upgrade --install my-jenkins jenkinsci/jenkins --version 4.1.13
    -n jenkins -f jenkins/jenkins.yaml

- update values

  - helm upgrade --install -f ./jenkins/values.yaml my-jenkins
    jenkinsci/jenkins

- uninstall chart

  - helm uninstall CHART-NAME

<table>
<tbody>
<tr class="odd">
<td><p># github webhook ip's</p>
<p>192.30.252.0/22</p>
<p>185.199.108.0/22</p>
<p>140.82.112.0/20</p>
<p>143.55.64.0/20</p>
<p>["your ip/32", "192.30.252.0/22", "185.199.108.0/22",
"140.82.112.0/20", "143.55.64.0/20"]</p>
<p># secret text: Mix3u</p>
<p># awsAddresss/github-webhook/</p>
<p># jenkins.yaml ----------------------------------------</p>
<p>controller:</p>
<p> # add you aws address here. Then uncomment. Don't forget to add
route name '/jenkins'.</p>
<p> # jenkinsUrl:
http://REDACTED-1924653928.us-east-1.elb.amazonaws.com/jenkins</p>
<p> # Do not change anything below</p>
<p> # ingress. tell jenkins your using ingress routes.</p>
<p> jenkinsUriPrefix: /jenkins</p>
<p> ingress:</p>
<p> enabled: true</p>
<p> apiVersion: "extensions/v1"</p>
<p> # ingress controller watches for this path in URI.</p>
<p> path: /jenkins</p>
<p> annotations:</p>
<p> ingressClassName: nginx</p>
<p> # kubernetes.io/ingress.class: nginx</p>
<p> additionalPlugins:</p>
<p> - github:1.34.5</p>
<p> agent:</p>
<p> namespace: jenkins</p>
<p># updated plugins //cannot use because helm crashes if forced.</p>
<p> - command-launcher:84.v4a_97f2027398</p>
<p> - configuration-as-code:1512.vb_79d418d5fc8</p>
<p> - cloudbees-folder:6.758.vfd75d09eea_a_1</p>
<p> - git:4.11.4</p>
<p> - javax-mail-api:1.6.2-7</p>
<p> - kubernetes:3670.v6ca_05923322</p>
<p> - mailer:438.v02c7f0a_12fa_4</p>
<p> - jdk-tool:55.v1b_32b_6ca_f9ca</p>
<p> - workflow-aggregator:590.v6a_d052e5a_a_b_5</p>
<p> - workflow-job:1232.v5a_4c994312f1</p>
<p> - sshd:3.249.v2dc2ea_416e33</p></td>
</tr>
</tbody>
</table>

\# create docker image to run helm

<table>
<tbody>
<tr class="odd">
<td><p>docker run -it --rm -v ${HOME}:/root/ -v ${PWD}:/work -w /work
--net host alpine sh<br />
<br />
# install curl &amp; kubectl<br />
apk add --no-cache curl nano<br />
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl
-s
https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl<br />
chmod +x ./kubectl<br />
mv ./kubectl /usr/local/bin/kubectl<br />
export KUBE_EDITOR="nano"<br />
<br />
# test cluster access:<br />
/work # kubectl get nodes<br />
NAME STATUS ROLES AGE VERSION<br />
helm-control-plane Ready master 26m v1.19.1<br />
</p>
<p># install helm</p>
<p># <a
href="https://github.com/helm/helm/releases">https://github.com/helm/helm/releases</a>
//helm binaries</p>
<p>curl -LO https://get.helm.sh/helm-v3.4.0-linux-amd64.tar.gz<br />
tar -C /tmp/ -zxvf helm-v3.4.0-linux-amd64.tar.gz<br />
rm helm-v3.4.0-linux-amd64.tar.gz<br />
mv /tmp/linux-amd64/helm /usr/local/bin/helm<br />
chmod +x /usr/local/bin/helm</p></td>
</tr>
</tbody>
</table>

\# run it

<table>
<tbody>
<tr class="odd">
<td>cd kubernetes/helm<br />
<br />
mkdir temp &amp;&amp; cd temp<br />
helm create example-app</td>
</tr>
</tbody>
</table>
