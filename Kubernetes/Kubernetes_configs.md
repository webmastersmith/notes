Kubernetes Deployment Config

vscode linter

disable limits warning //setting.json

<table>
<tbody>
<tr class="odd">
<td><p>{</p>
<p> "vs-kubernetes": {</p>
<p> "disable-linters": ["resource-limits"],</p>
<p> ...</p>
<p> },</p>
<p> ...</p>
<p>}</p></td>
</tr>
</tbody>
</table>

3 parts of config file

- metadata:

  - purpose: allow deployment / service/ ingress to connect

  - name: nginx-deployment // deployment name.

  - labels:

    - app: nginx // key:value pair. top is global, used by the service.

- spec: //specification for every kind of configuration you want to
  apply

  - attributes will specific to the 'kind' of config.

  - apiVersion: app/v1 //version

  - kind: Deployment (Deployment \| Service) //what kind of config file
    your creating.

  - selector: //reference label in metadata.

  - template: //config for the pod.

    - config inside of config.

      - this config applies to pod

    - metadata

      - label:

    - spec

      - // blueprint for the pod
      - selector: //contect to label.

- status

  - k8s creates this. k8s compares 'desired' with 'actual' and makes
    changes. This is the basis for the self healing feature.
  - status info comes from the 'ETCD'

configmap

- [_https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/)
- links db to app
- must be applied into cluster before deployment!
- cannot be shared across namespace

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: v1</p>
<p>kind: ConfigMap</p>
<p>metadata:</p>
<p> name: myconfigmap</p>
<p> namespace: default # assigns to namespace. Can only be used inside
this namespace.</p>
<p> labels: # optional</p>
<p> app: myapplication # optional</p>
<p>data:</p>
<p> my-key: my-value</p>
<p># to access something in another namespace</p>
<p>data:</p>
<p> db_url: SERVICE-NAME.NAMESPACE</p></td>
</tr>
</tbody>
</table>

to use:

<table>
<tbody>
<tr class="odd">
<td><p> env:</p>
<p> - name: ME_CONFIG_MONGODB_SERVER # points to address/ internal
service = mongo-svc</p>
<p> valueFrom:</p>
<p> configMapKeyRef:</p>
<p> name: mongo-configmap # ConfigMap.metadata.name</p>
<p> key: database_url # ConfigMap.data.key</p></td>
</tr>
</tbody>
</table>

Deployment

- [_https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/)

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: apps/v1</p>
<p>kind: Deployment</p>
<p>metadata:</p>
<p> name: mongo-dev # name of deployment</p>
<p> namespace: default</p>
<p> labels:</p>
<p> pod: mongo # key:value to reference for Service file.</p>
<p>spec:</p>
<p> replicas: 1</p>
<p> selector:</p>
<p> matchLabels:</p>
<p> pod: mongo # should match Deployment.metadata.labels.</p>
<p> template:</p>
<p> metadata:</p>
<p> labels:</p>
<p> pod: mongo # should match Deployment.metadata.labels.</p>
<p> spec:</p>
<p> containers:</p>
<p> - resources:</p>
<p> requests:</p>
<p> cpu: "50m"</p>
<p> memory: "256Mi"</p>
<p> limits:</p>
<p> cpu: "2000m"</p>
<p> memory: "4096Mi"</p>
<p> name: mongo # docker container name.</p>
<p> image: mongo/mongo:alpine # docker image to pull</p>
<p> imagePullPolicy: IfNotPresent # pull local first.</p>
<p> env:</p>
<p> - name: DEMO_GREETING</p>
<p> value: "Hello from the environment"</p>
<p> - name: DEMO_FAREWELL</p>
<p> value: "Such a sweet sorrow"</p>
<p> ports:</p>
<p> - name: mongo-port # name of port </p>
<p> containerPort: 8080 # port pod is listening on.</p>
<p> # - name: discovery-port</p>
<p> # containerPort: 50000</p>
<p> # volumeMounts:</p>
<p> # - name: mongo-vol</p>
<p> # mountPath: /var/mongo_vol</p>
<p> # volumes:</p>
<p> # - name: mongo-vol</p>
<p> # emptyDir: {}</p></td>
</tr>
</tbody>
</table>

nginx-deployment.yaml

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: apps/v1</p>
<p>kind: Deployment</p>
<p>metadata:</p>
<p> name: nginx-deployment //display name of Deployment when: kubectl
get deployments</p>
<p> labels:</p>
<p> app: nginx //name of the pods</p>
<p>spec: //define how many pods and replicas.</p>
<p> replicas: 1</p>
<p> selector: //define how Deployment should find pods.</p>
<p> matchLabels: //find pod by matching key and value.</p>
<p> app: nginx</p>
<p> template: //describe how to build the pod. Rollout triggered only if
this is changed.</p>
<p> metadata:</p>
<p> labels: //label each pod with</p>
<p> app: nginx</p>
<p> spec: //describe how many containers should run in a pod</p>
<p> containers:</p>
<p> - name: nginx-depl //container name.
spec.template.spec.containers[0].name field.</p>
<p> image: nginx:alpine</p>
<p> ports:</p>
<p> - containerPort: 80 //port app is listening on.</p></td>
</tr>
</tbody>
</table>

enviroment variables

- <https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/>

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: v1</p>
<p>kind: Pod</p>
<p>metadata:</p>
<p> name: envar-demo</p>
<p> labels:</p>
<p> purpose: demonstrate-envars</p>
<p>spec:</p>
<p> containers:</p>
<p> - name: envar-demo-container</p>
<p> image: gcr.io/google-samples/node-hello:1.0</p>
<p> env:</p>
<p> - name: DEMO_GREETING # the key of env variable.</p>
<p> value: "Hello from the environment"</p>
<p> - name: DEMO_FAREWELL</p>
<p> value: "Such a sweet sorrow"</p></td>
</tr>
</tbody>
</table>

Ingress

- [_https://kubernetes.io/docs/reference/kubernetes-api/service-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/)
- you also apply ingressClass

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: networking.k8s.io/v1</p>
<p>kind: Ingress</p>
<p>metadata:</p>
<p> name: jenkins-ingress # name of ingress. will overwrite other
ingress files if name same.</p>
<p> annotations:</p>
<p> ingressClassName: nginx # nginx needs to have class enabled.</p>
<p>spec:</p>
<p> rules:</p>
<p> - http: # tells nginx that incoming request get forwarded to
internal service</p>
<p> paths: # points to everything after the url: smithauto.us/(all
this)</p>
<p> - path: /jenkins</p>
<p> pathType: Prefix</p>
<p> backend: # targets the Service file 'ports:' section</p>
<p> service:</p>
<p> name: jenkins-ui #should be the same as Service.metadata.name</p>
<p> port:</p>
<p> number: 8080 # same as Service.spec.ports.port</p></td>
</tr>
</tbody>
</table>

ingress class

- to enable class in ingress-nginx //enabled by default in helm
  ingress-nginx

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: networking.k8s.io/v1</p>
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

Ingress helm Jenkins

<table>
<tbody>
<tr class="odd">
<td><p>controller:</p>
<p> # add you aws address here. Then uncomment. Don't forget to add
route name '/jenkins'.</p>
<p> #jenkinsUrl:
http://14843.us-east-1.elb.amazonaws.com/jenkins</p>
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
<p> additionalPlugins:</p>
<p> - github:1.34.5</p>
<p> agent:</p>
<p> namespace: jenkins</p></td>
</tr>
</tbody>
</table>

namespace

- [_https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/)

- advantages of namespace file is it creates a record of the namespaces
  you have.

- you cannot share configmap or secrets across namespace.

- install volumes globally

  - kubectl api-resources --namespaced=false

custom-namspace.yaml

- kubectl apply -f custom-namespace.yaml
- kubectl config set-context --current --namespace=my-namespace

<!-- -->

- [_https://kubernetes.io/docs/tasks/administer-cluster/namespaces/_](https://kubernetes.io/docs/tasks/administer-cluster/namespaces/)

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: v1</p>
<p>kind: Namespace</p>
<p>metadata:</p>
<p> name: app # create namespace app.</p>
<p>---</p>
<p># other app stuff # this creates namespace, so you can make several
different namespaces per app. </p></td>
</tr>
</tbody>
</table>

Secrets

- <https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/>
- secrets must be applied before deployment.
- cannot be shared across namespace

mongo-secret.yaml

- this must be made first. because deployment will need secret to start.

  - kubectl apply -f mongo-secret.yaml

- <https://kubernetes.io/docs/concepts/configuration/secret/>

- your secrects go here.

- values must be encrypted

  - echo -n 'mongo' \| base64 //output base64

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: v1</p>
<p>kind: Secret</p>
<p>metadata:</p>
<p> name: mongo-secret</p>
<p> namespace: default # can only be used inside this namespace.</p>
<p>type: Opaque # value type: tls, <a
href="https://kubernetes.io/docs/concepts/configuration/secret/#secret-types">https://kubernetes.io/docs/concepts/configuration/secret/#secret-types</a></p>
<p>data:</p>
<p> # secret need to be BASE64_ENCODED_VALUE # echo -n 'password' | base
64 //do not print newline</p>
<p> mongo-root-username: bW9uZ28= # mongo</p>
<p> mongo-root-password: cGFzc3dvcmQ= # password</p></td>
</tr>
</tbody>
</table>

deployment.yaml

<table>
<tbody>
<tr class="odd">
<td><p> containers:</p>
<p> - name: mongodb</p>
<p> image: mongo</p>
<p> resources:</p>
<p> limits:</p>
<p> memory: 512Mi</p>
<p> cpu: "1"</p>
<p> requests:</p>
<p> memory: 256Mi</p>
<p> cpu: "0.2"</p>
<p> ports:</p>
<p> - containerPort: 27017</p>
<p> env:</p>
<p> - name: MONGO_INITDB_ROOT_USERNAME # the name used in the env
file.</p>
<p> valueFrom:</p>
<p> secretKeyRef:</p>
<p> name: mongo-secret # name of Secret.metadata.name</p>
<p> key: mongo-root-username # Secret.data.key = mongo-root-username</p>
<p> - name: MONGO_INITDB_ROOT_PASSWORD</p>
<p> valueFrom:</p>
<p> secretKeyRef:</p>
<p> name: mongo-secret</p>
<p> key: mongo-root-password</p></td>
</tr>
</tbody>
</table>

docker secrets

<table>
<tbody>
<tr class="odd">
<td><p>kubectl create secret docker-registry dockerhub \</p>
<p>--docker-server=docker.io \</p>
<p>--docker-username=YOUR_DOCKER_HUB_USERNAME \</p>
<p>--docker-password=YOUR_DOCKER_HUB_PASSWORD</p></td>
</tr>
</tbody>
</table>

Service

- [_https://kubernetes.io/docs/reference/kubernetes-api/service-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/)

- [_https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/_](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)

- service config

  - targetPort: 8080 //tell service which port pod is listening on.

    - should match the containerPort in the 'deployment' config.

  - kubectl describe service nginx-service

- "**ClusterIP**" (default) means a service will only be accessible
  inside the cluster, via the cluster IP.

- "ExternalName" means a service consists of only a reference to an
  external name that kubedns or equivalent will return as a CNAME
  record, with no exposing or proxying of any pods involved.

- "**LoadBalancer**" means a service will be exposed via an external
  load balancer (if the cloud provider supports it), in addition to
  'NodePort' type.

- "**NodePort**" means a service will be exposed on one port of every
  node, in addition to 'ClusterIP' type.

file.yaml

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: v1</p>
<p>kind: Service</p>
<p>metadata:</p>
<p> name: jenkins-svc # name of Service. kubectl get service jenkins</p>
<p> namespace: jenkins</p>
<p>spec:</p>
<p> type: LoadBalancer #(ClusterIp (default), NodePort,
LoadBalancer)</p>
<p> selector: # Route service traffic to pods/deployment with label
key:values matching this selector. </p>
<p> pod: jenkins</p>
<p> ports:</p>
<p> - name: jenkins</p>
<p> protocol: TCP</p>
<p> port: 8080 # port to open on node for incoming request</p>
<p> targetPort: 8080 # port to pod is listening on.</p>
<p> # nodePort: 30000 # (30000-32767) Expose the node port to the
outside world. nodePort is a static IP on the node.</p></td>
</tr>
</tbody>
</table>

Internal Service -pods can talk to each other.

Headless Service

- d

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: v1</p>
<p>kind: Service</p>
<p>metadata:</p>
<p> name: jenkins # name of Service. kubectl get service jenkins</p>
<p>spec:</p>
<p> type: None # this causes dns lookup to return pod ip addresses. For
db stuff. 'None' will be listed under ip address.</p>
<p>...</p></td>
</tr>
</tbody>
</table>

StatefulSet

- [_https://kubernetes.io/docs/concepts/workloads/controllers/_](https://kubernetes.io/docs/concepts/workloads/controllers/)

- [_https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/_](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/)

- [_https://kubernetes.io/docs/tasks/debug/debug-application/debug-statefulset/_](https://kubernetes.io/docs/tasks/debug/debug-application/debug-statefulset/)

- stateful apps

  - keep state in backend. protects data and state.

  - statefulset does same thing as deployment, but keeps an id on db
    pods, because it can't update and delete them the same way as
    deployment.

    - more than one db pod, one will be called master and it will be
      able to read and write, the others will be slaves, they can read
      only.

    - each pod will have it's own replica of storage (PV). all volumes
      must continously syncronize data.

      - master changes data, and all slave update their own PV to keep
        in sync.
      - any new pod that's added will have it's own PV, then it will
        clone data from previous pod, then syncronize along with the
        others.
      - good to have persistant storage, so if pods die, data will
        survive.
      - when pod dies, PV gets re-attached to pod. That tells it if it's
        a master or slave.
      - better to have remote storage, so if pod gets moved to another
        node, then storage is still available.

    - pods get fixed ordered names.\$(statefulset name)-\$(ordinal)
      //starts at 0, then 1, then 2, ...

    - pods get own service route. (mysql-0.svc2, mysql-1.svc2)

- stateless apps

  - do not keep state, each request is completly new
  -

Volumes //PV & PersistentVolumeClaims PVC

- <https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/>
- <https://kubernetes.io/docs/concepts/storage/volumes/>
- <https://kubernetes.io/docs/concepts/storage/persistent-volumes/>
- attach to another source to persist data. Cloud storage, local storage
  or outside kubernetes cluster.
- PV are not namespaced. There available to all cluster.
- survive if cluster crashes.
- k8s does not track data for you.

PersistantVolume

- <https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes>

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: v1</p>
<p>kind: PersistentVolume</p>
<p>metadata:</p>
<p> name: pv0003</p>
<p>spec:</p>
<p> capacity:</p>
<p> storage: 5Gi</p>
<p> volumeMode: Filesystem</p>
<p> accessModes:</p>
<p> - ReadWriteOnce</p>
<p> persistentVolumeReclaimPolicy: Recycle</p>
<p> storageClassName: slow</p>
<p> mountOptions:</p>
<p> - hard</p>
<p> - nfsvers=4.1</p>
<p> nfs:</p>
<p> path: /tmp</p>
<p> server: 172.17.0.2</p></td>
</tr>
</tbody>
</table>

PersistantVolumeClaim //works with the storage class api

- <https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims>
- They are namespaced
- They claim the data and have to referenced in the deployment pod yaml.

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: v1</p>
<p>kind: PersistentVolumeClaim</p>
<p>metadata:</p>
<p> name: myclaim</p>
<p>spec:</p>
<p> accessModes:</p>
<p> - ReadWriteOnce</p>
<p> volumeMode: Filesystem</p>
<p> resources:</p>
<p> requests:</p>
<p> storage: 8Gi</p>
<p> storageClassName: slow</p>
<p> selector:</p>
<p> matchLabels:</p>
<p> release: "stable"</p>
<p> matchExpressions:</p>
<p> - {key: environment, operator: In, values: [dev]}</p></td>
</tr>
</tbody>
</table>

Storage Class

- <https://kubernetes.io/docs/concepts/storage/storage-classes/>
- dynamically created volumes when pvc claims it.

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: storage.k8s.io/v1</p>
<p>kind: StorageClass</p>
<p>metadata:</p>
<p> name: standard</p>
<p>provisioner: kubernetes.io/aws-ebs</p>
<p>parameters:</p>
<p> type: gp2</p>
<p>reclaimPolicy: Retain</p>
<p>allowVolumeExpansion: true</p>
<p>mountOptions:</p>
<p> - debug</p>
<p>volumeBindingMode: Immediate</p></td>
</tr>
</tbody>
</table>

On local machine

- <https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/>
- After you create the PersistentVolumeClaim, the Kubernetes control
  plane looks for a PersistentVolume that satisfies the claim's
  requirements. If the control plane finds a suitable PersistentVolume
  with the same StorageClass, it binds the claim to the volume.

<table>
<tbody>
<tr class="odd">
<td><p># persistant volume</p>
<p>apiVersion: v1</p>
<p>kind: PersistentVolume</p>
<p>metadata:</p>
<p> name: task-pv-volume</p>
<p> labels:</p>
<p> type: local</p>
<p>spec:</p>
<p> storageClassName: manual</p>
<p> capacity:</p>
<p> storage: 12Gi</p>
<p> accessModes:</p>
<p> - ReadWriteOnce</p>
<p> hostPath:</p>
<p> path: "/mnt/data" # sudo mkdir /mnt/data; sudo sh -c "echo 'Hello
from kubernetes' &gt; /mnt/data/index.html"</p>
<p># persistentVoumeClaim</p>
<p>apiVersion: v1</p>
<p>kind: PersistentVolumeClaim</p>
<p>metadata:</p>
<p> name: task-pv-claim</p>
<p>spec:</p>
<p> storageClassName: manual</p>
<p> accessModes:</p>
<p> - ReadWriteOnce</p>
<p> resources:</p>
<p> requests:</p>
<p> storage: 3Gi</p></td>
</tr>
</tbody>
</table>
