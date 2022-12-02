# Kubectl

- **cheat sheet**
- [_https://kubernetes.io/docs/reference/kubectl/cheatsheet/_](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

- **cli**
- <https://kubectl.docs.kubernetes.io/references/kubectl/>

- **troubleshooting**

```bash
kubectl create -h # get, create,
# add --v=99 to any command to get more info
# <https://blog.pilosus.org/posts/2019/05/26/k8s-ingress-troubleshooting/>
kubectl get endpoints -n jenkins
kubectl describe ingress my-jenkins -n jenkins
kubectl describe svc apple-service -n app
kubectl cluster-info dump
```

- **install**
- <https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/>
- kubectl version --client --output=yaml
- **info**
- <https://minikube.sigs.k8s.io/docs/handbook/troubleshooting/>
- kubectl cluster-info //show ip
- kubectl cluster-info dump //show all information
- kubectl get po -A
- kubectl describe pod \<name\> -n \<namespace\>
- minikube ip //expose minikube ip. 192.168.49.2
  - kubectl get service \<service-name\>
    --output='jsonpath="{.spec.ports\[0\].nodePort}"'

## Commands (adjectives)

- **apply**
- config can be edited and run again. k8s knows when to create or modify pods.
- `kubectl apply -f configFile.yaml` // load config

## Config

```bash
kubectl config view # show ~/.kube/config contents
kubectl config get-contexts # show where your config is pointint to.
kubectl config use-context docker-desktop # switch to local environment.
```

## Kubectl Methods

- **create** // create a pod
  - kubectl create -h
    - kubectl create deployment NAME --image=image -- \[COMMAND\] \[args...\] \[options\]
- **delete**
  - point kubectl to your yaml files to remove them running or not.
    - kubectl delete -f /pathToYamls/ // will delete all running item listed int the yaml files.
  - kubectl delete deployment deploymentNameFromGetDeployment //only way to add or delete pods.
  - kubectl delete -f FILE.yaml
  - kubectl delete all --all -n app
    - To delete everything from the current namespace (which is normally
      the default namespace) using kubectl delete
    - delete everything but kubernetes pod.
  - kubectl delete ns NAME_SPACE -does not delete some ingress items.
  - kubectl delete all --all -n {namespace}
    - To delete everything from a certain namespace you use the -n flag:
- **describe**
  - get info about the pod
  - kubectl describe podNameFromGetPod // if container is not running, can get info about it.
  - kubectl describe ingress jenkins
- **edit**
  - kubectl edit -h
    - kubectl edit deployment NAME //**outputs to nano a editable config file. **(if nano default editor.)
  - to use nano as editor
    - .bashrc: export KUBE_EDITOR="/bin/nano"
- **endpoints**
  - if no endpoints -means you have no virtual ip address.
  - kubectl get endpoints -n jenkins
- **exec**
  - ssh into pod
    - `kubectl exec -it podName -- /bin/bash` // don't forget the '--'.
    - `kubectl exec -it POD-NAME -n app -- sh` // shell
  - ssh into node
- **expose** // expose outside ports for minikube
  - kubectl expose deployment deploymentNameFromGetDeployment
  - --type=NodePort
  - --type `(ClusterIP | NodePort | LoadBalancer)`
  - --port // host port you want to connect on
  - --target-port //pod port you want to expose.
  - if ClusterIP it will only available inside cluster private network.
- **logs**
  - <https://kubernetes.io/docs/concepts/cluster-administration/logging/>
  - `k logs --help`
  - `kubectl logs (--follow | -f) podName` // watch logs.
- **NodePort**
  - NodePort and LoadBalancer open ports to external world.
    - `k get svc` // 3000:30486/TCP the one over 30,000 you can connect to
      - `curl -i $(minikube ip):30486`
      - can also use in web browser, but linux browser not working
  - LoadBalancer
    - same as NodePort
  - kubectl get svc
  - <https://minikube.sigs.k8s.io/docs/handbook/accessing/>
  - <https://shubham-singh98.medium.com/minikube-dashboard-in-aws-ec2-881143a2209e>
  - <https://aws.amazon.com/premiumsupport/knowledge-center/eks-kubernetes-services-cluster/>
  - <https://www.eksworkshop.com/beginner/130_exposing-service/exposing/>
  - check if node port is visible to internet
    - `kubectl get nodes -o wide | awk {'print $1" " $2 " " $7'} | column -t`
  - LoadBalancer
    - if you have nodePort under ports, don't need anything else. just run:
      - `kubectl get svc SERVICE-NAME`
    - check dns name.
      - `curl -silent ...eu-west-1.elb.amazonaws.com:80 | grep title`
- **namespace**
  - kubectl config set-context --current --namespace=my-namespace // create and switch to namespace.
  - validate current namespace:
    - `kubectl config view | grep namespace`

### flags

- ns \| -n //namespace
- -A //--all-namespaces

## get //status

- `kubectl get (all | nodes | pod(s) | services | deployment | (replicaset | rs) | svc)` // svc show ip. rs=replica set
- kubectl get all -o wide // show all: service, deployment, pod/pod ip and replicaset.
- kubectl get srv // check internal and external ip address

## ingress

- kubectl get ingress -n jenkins
- kubectl delete ingress my-ingress -n app

## labels

- <https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors>
- matchLabels:
  - app: jenkins

## namespace

- flags: ns \| -n \| namespace //k get namespace -A //get --all-namespaces
- kubectl get namespace //show current namespace
- kubectl create namespace aznamespace
- kubectl delete namespace NAME-SPACE
- kubectl delete namespace {namespace}
  - deletes everything associated with namespace
- kubectl create namespace {namespace}
  - You can also delete a namespace and re-create it. This will delete everything that belongs to it:
- kubectl create -f deployment.yaml --namespace=custom-namespace
  - port-forward // (pods \| svc \| service \| deployment)
- kubectl port-forward svc/SERVICE-NAME HOST-PORT -n NAMESPACE-NAME
- kubectl port-forward svc/SERVICE-NAME HOST-PORT:POD-PORT
- kubectl port-forward --address 0.0.0.0 pod/nginx 8080:80 //all ip addresses
- kubectl port-forward --address 0.0.0.0 svc/nginx 8080:80 //all ip addresses
- background
  - kubectl port-forward svc/SERVICE-NAME HOST-PORT:POD-PORT &

## replace

- kubectl replace --force -f ./pod.json

## run

- k run nginx --image=nginx //nginx is name of pod

## service or svc // same thing

- k describe svc nginx-deploy

## scale

- kubectl scale deployment deploymentNameFromGetDeployments --replicas=3

## update/rollout

- <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment>
- Deployment's rollout is triggered if and only if the Deployment's Pod template (that is, .spec.template) is changed,
- rollout update
  - kubectl set image deployment/DEPLOY-NAME CONTAINER_NAME=NEW_IMAGE_NAME
    - container-name must be the name of a container you specified inside your deployment under spec.template.spec.containers.name.
  - kubectl set image deployment DEPLOY-NAME IMAGE-NAME=IMAGE-REPO/IMAGE-NAME:TAG
  - kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.16.1
  - kubectl set image deployment/flask-deployment flaskapp=ownerName/imageName:sha256
- **rollout status**
  - kubectl rollout status deployment DEPLOY-NAME
  - kubectl rollout status deployment node
  - view deployment history
    - kubectl rollout history deployment/deploymentName
- **rollback**
  - kubectl rollout undo deployment DEPLOY-NAME
  - or to specific revision
  - kubectl rollout undo deployment nginx-deployment --to-revision=2

**update kube-config**

- [_https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html_](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

```sh
aws sts get-caller-identity # whoami for aws
aws eks update-kubeconfig --region region-code --name my-cluster
aws eks update-kubeconfig --profile 2206-devops-mehrab --name 2206-devops-cluster --region us-east-1
kubectl get svc # check external ip

# on aws cluster
aws eks --region REGION update-kubeconfig --name CLUSTER
aws eks --region us-east-1 update-kubeconfig --name bryon-cluster
aws eks --profile profileName --region us-east-1 update-kubeconfig --name my-cluster

# Terraform
output "region" {
 description = "AWS region"
 value = var.region
}
output "cluster_name" {
 description = "Kubernetes Cluster Name"
 value = local.cluster_name
}
# cmd
aws eks --region $(terraform output -raw region) update-kubecofig --name $(terraform output -raw cluster_name)
```

- [_https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/_](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)

- view current config

  - kubectl config view

## volumes

- k get pvc PVC-NAME //pv as well
- k describe pvc PVC-NAME
- k delete pvc PVC-NAME

## watch

- kubectl --namespace default get services -o wide -w my-ingress-nginx-controller

**bash script**

```sh
minikube start
minikube status
minikube ip
kubectl get pods all
kubectl cluster-info
# run yaml
kubectl apply -f "/home/webmaster/documents/BRT_Project2/kubernetes/mongo-secrets.yaml"
kubectl apply -f "/home/webmaster/documents/BRT_Project2/kubernetes/mongo-express-configmap.yaml"
kubectl apply -f "/home/webmaster/documents/BRT_Project2/kubernetes/mongodb-express-deployment.yaml"
kubectl apply -f "/home/webmaster/documents/BRT_Project2/kubernetes/mongodb-deployment.yaml"
```

# Minikube

- virtual box runtime with master and worker node along with docker
  installed.
- minikube is both master and worker node. It only creates **one node**.
- [_https://minikube.sigs.k8s.io/docs/start/_](https://minikube.sigs.k8s.io/docs/start/)
- [_https://minikube.sigs.k8s.io/docs/commands/_](https://minikube.sigs.k8s.io/docs/commands/)
  - minikube start/stop/delete //does not auto start.
    - alias m=minikube
  - minikube status //will error if not running.
  - minikube dashboard
  - minikube service serviceNameFromGetService //show browser.
  - minikube ip //show ip address assigned to minikube
  - kubectl get-info //show ip of docker container running the control plane
  - docker ps //look for docker container running control-plane
  - ip a s eth0 // inet -find my ip
  - ip addr \| grep eth0 //wsl bash script 172.28.6.138
- **minikube start \| stop \| delete \| dashboard \| status \| pause \| unpause**
  - kubectl create deployment hello-minikube1 --image=k8s.gcr.io/echoserver:1.4
- **minikube ingress**
  - ssh
    - minikube ip //show ip of cluster //ssh docker@\$(minikube ip) //user: docker pw: tcuser
    - <https://minikube.sigs.k8s.io/docs/commands/ssh/>
      - minikube ssh //ssh into control plane by default
        - docker ps //show all containers running
  - minikube addons enable ingress
  - minikube tunnel //connect load-balancer to service
  - minikube service //returns ip to connect
    - **minikube service SERVICE-NAME ** //allows you to connect to nginx pod service
  - k cluster-info
  - connect to pod
    - k exec POD-NAME -- nslookup nginx //returns pod address
    - k exec POD-NAME -- curl -i http://SERVICE-NAME
- **debug**
  - minikube logs

# Kind

- <https://kind.sigs.k8s.io/>
- <https://hub.docker.com/r/kindest/node/tags>
- kind delete cluster
- kindest/node //prebuilt kubernetes images from kind

<table>
<tbody>
<tr class="odd">
<td><p># same as </p>
<p>kind create cluster --name CUSTOM_NAME --image
kindest/node:v1.24.2</p>
<p># delete cluster</p>
<p>kind delete cluster --name NAME</p></td>
</tr>
</tbody>
</table>

- kind create cluster --image=ownerAccount/imageName:tagName //can leave off image attribute

delete

- kind delete cluster -kubectl (talk to master node api)

- kubectl describe cm aws-auth kube-system

docker

- `docker ps | grep nginx` // shows two containers. one is pod. other is '/pause container' // a container that holds the namespace of the pod.

- once inside control plane

  - `docker exec -it CONTAINER_NAME sh`

    - hostname // nginx
    - hostname -i // get ip address
