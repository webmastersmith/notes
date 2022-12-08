Kubernetes Deployment Config

vscode linter

disable limits warning //setting.json

```json
{
    "vs-kubernetes": {
        "disable-linters": ["resource-limits"],
        ...
    },
    ...
}
```

**3 parts of kubernetes yaml config file**

- **metadata**:
  - purpose: allow (deployment | service | ingress) to connect.
  - name: nginx-deployment // deployment name.
  - labels:
    - app: nginx // key:value pair. top is global, used by the service.
- **spec**: //specification for every kind of configuration you want to apply
  - attributes will specific to the 'kind' of config.
  - apiVersion: app/v1 //version
  - kind: Deployment (Deployment \| Service) //what kind of config file your creating.
  - selector: //reference label in metadata.
  - template: //config for the pod.
    - config inside of config.
      - this config applies to pod
    - metadata
      - label:
    - spec
      - // blueprint for the pod
      - selector: // connects to label.
- **status**
  - k8s creates this. k8s compares 'desired' with 'actual' and makes changes. This is the basis for the self healing feature.
  - status info comes from the 'ETCD'

## configmap

- [_https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/)
- links db to app
- must be applied into cluster before deployment!
- cannot be shared across namespace

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfigmap
  namespace: default  # assigns to namespace. Can only be used inside this namespace.
  labels:  # optional
    app: myapplication  # optional
data:
  my-key: my-value

# to access something in another namespace
data:
  db_url: SERVICE-NAME.NAMESPACE
```

**to use:**

```yaml
env:
  - name: ME_CONFIG_MONGODB_SERVER # points to address/ internal service = mongo-svc
    valueFrom:
      configMapKeyRef:
        name: mongo-configmap # ConfigMap.metadata.name
        key: database_url # ConfigMap.data.key
```

# Pod

- https://kubernetes.io/docs/concepts/workloads/pods/
- usually don't create pods this way. Use deployments
- kubernetes will not automatically manage pods created this way.
- when pod dies, will not be re-created.?

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: posts
spec:
  containers:
    - name: posts
      imagePullPolicy: Never
      image: posts:0.0.1
      ports:
        - containerPort: 4000
      resources:
        requests:
          memory: '64Mi'
          cpu: '250m'
        limits:
          memory: '128Mi'
          cpu: '500m'
```

# Deployment

- [_https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/)
- <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>
- describes pods and tells kubernetes to manage pods.
- pods created from deployment, will automatically be re-created when they die.

```yaml

# another example
apiVersion: apps/v1
kind: Deployment
metadata:
  name: posts-depl # deployment name. kubectl get deployment
  labels:
    app: posts # name of pod
spec:
  replicas: 1
  selector: # how to find pods to manage.
    matchLabels: # looks at key:value pair. 'app:posts' both have to match.
      app: posts # label of pod (spec.template.metadata.labels.app) you want replicas of.
  template: # how kubernetes should create the pod.
    metadata:
      labels:
        app: posts # all replicas label with 'app:posts'.
    spec:
      containers:
        - name: posts # name of container
          imagePullPolicy: Never # do not pull image from docker hub.
          image: posts:0.0.1 # name of local image.
          ports:
            - containerPort: 4000 # connect pod port 4000 to nodePort.
          resources: # restrict resources.
            requests:
              memory: '64Mi' # At least 64Mi (Mi = Megabytes, Gi = Gigabytes).
              cpu: '250m' # "thousandth of a core" 250m/1000m = 25% of one core. 2000m is 2 cores. millicores.
            limits:
              memory: '128Mi' # but not more than
              cpu: '500m' # but not more than 500m/1000m = 1/2 core.

# Mongo Example
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo-dev   # name of deployment
  namespace: default
  labels:
    pod: mongo  # key:value to reference for Service file.
spec:
  replicas: 1
  selector:
    matchLabels:
      pod: mongo  # should match Deployment.metadata.labels.
  template:
    metadata:
      labels:
        pod: mongo  # should match Deployment.metadata.labels.
    spec:
      containers:
      - resources:
          requests:
            cpu: "50m"
            memory: "256Mi"
          limits:
            cpu: "2000m"
            memory: "4096Mi"
        name: mongo  # docker container name.
        image: mongo/mongo:alpine  # docker image to pull
        imagePullPolicy: IfNotPresent  # pull local first.
        env:
        - name: DEMO_GREETING
          value: "Hello from the environment"
        - name: DEMO_FAREWELL
          value: "Such a sweet sorrow"
        ports:
        - name: mongo-port  # name of port
          containerPort: 8080  # port pod is listening on.
        # - name: discovery-port
        #   containerPort: 50000
    #   volumeMounts:
    #     - name: mongo-vol
    #       mountPath: /var/mongo_vol
    # volumes:
    #   - name: mongo-vol
    #     emptyDir: {}

# nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment  //display name of Deployment when: kubectl get deployments
  labels:
    app: nginx  //name of the pods
spec:  //define how many pods and replicas.
  replicas: 1
  selector:  //define how Deployment should find pods.
    matchLabels:  //find pod by matching key and value.
      app: nginx
  template:  //describe how to build the pod. Rollout triggered only if this is changed.
    metadata:
      labels:  //label each pod with
        app: nginx
    spec:  //describe how many containers should run in a pod
      containers:
      - name: nginx-depl  //container name.  spec.template.spec.containers[0].name field.
        image: nginx:alpine
        ports:
          - containerPort: 80  //port app is listening on.
```

# environment variables

- <https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/>

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: envar-demo
  labels:
    purpose: demonstrate-envars
spec:
  containers:
    - name: envar-demo-container
      image: gcr.io/google-samples/node-hello:1.0
      env:
        - name: DEMO_GREETING # the key of env variable.
          value: 'Hello from the environment'
        - name: DEMO_FAREWELL
          value: 'Such a sweet sorrow'
```

# Ingress

- [_https://kubernetes.io/docs/reference/kubernetes-api/service-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/)
- you also apply ingressClass

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: jenkins-ingress # name of ingress. will overwrite other ingress files if name same.
  annotations:
    ingressClassName: nginx # nginx needs to have class enabled.
spec:
  rules:
    - http: # tells nginx that incoming request get forwarded to internal service
        paths: # points to everything after the url: email/(all this)
          - path: /jenkins
            pathType: Prefix
            backend: # targets the Service file 'ports:' section
              service:
                name: jenkins-ui #should be the same as Service.metadata.name
                port:
                  number: 8080 # same as Service.spec.ports.port

# Another Example
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-srv
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/enable-cors: 'true'
    nginx.ingress.kubernetes.io/use-regex: 'true' # to use regex in routes.
spec:
  rules:
    - host: tickets.prod
      http:
        paths:
          - path: /api/v[0-9]{1,3}/users/.+ # regex path.
            pathType: Prefix
            backend:
              service:
                name: auth-svc
                port:
                  number: 80

```

## ingress class

- to enable class in ingress-nginx //enabled by default in helm

**ingress-nginx**

```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  labels:
    app.kubernetes.io/component: controller
  name: nginx
  annotations:
    ingressclass.kubernetes.io/is-default-class: 'true'
spec:
  controller: k8s.io/ingress-nginx
```

**Ingress helm Jenkins**

```yaml
controller:
  # add you aws address here. Then uncomment. Don't forget to add route name '/jenkins'.
  #jenkinsUrl: http://a6b5c843.us-east-1.elb.amazonaws.com/jenkins

  # Do not change anything below
  # ingress. tell jenkins your using ingress routes.
  jenkinsUriPrefix: /jenkins
  ingress:
    enabled: true
    apiVersion: 'extensions/v1'
    # ingress controller watches for this path in URI.
    path: /jenkins
    annotations:
      ingressClassName: nginx
  additionalPlugins:
    - github:1.34.5
  agent:
    namespace: jenkins
```

# namespace

- [_https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/)
- advantages of namespace file is it creates a record of the namespaces you have.
- you cannot share configmap or secrets across namespace.
- install volumes globally
  - kubectl api-resources --namespaced=false

**custom-namspace.yaml**

- kubectl apply -f custom-namespace.yaml
- kubectl config set-context --current --namespace=my-namespace
- [_https://kubernetes.io/docs/tasks/administer-cluster/namespaces/_](https://kubernetes.io/docs/tasks/administer-cluster/namespaces/)

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: app # create namespace app.
---
# other app stuff # this creates namespace, so you can make several different namespaces per app.
```

# Secrets

- <https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/>
- secrets must be applied before deployment.
- cannot be shared across namespace

**mongo-secret.yaml**

- this must be made first. because deployment will need secret to start.
  - kubectl apply -f mongo-secret.yaml
- <https://kubernetes.io/docs/concepts/configuration/secret/>
- your secrets go here.
- values must be encrypted
  - echo -n 'mongo' \| base64 //output base64

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
  namespace: default # can only be used inside this namespace.
type: Opaque # value type: tls,  https://kubernetes.io/docs/concepts/configuration/secret/#secret-types
data:
  # secret need to be BASE64_ENCODED_VALUE  # echo -n 'password' | base 64  //do not print newline
  mongo-root-username: bW8= # mongo
  mongo-root-password: cG3Q= # password
```

**deployment.yaml**

- to use the secrets.

```yaml
containers:
  - name: mongodb
    image: mongo
    resources:
      limits:
        memory: 512Mi
        cpu: '1'
      requests:
        memory: 256Mi
        cpu: '0.2'
    ports:
      - containerPort: 27017
    env:
      - name: MONGO_INITDB_ROOT_USERNAME # the name used in the env file.
        valueFrom:
          secretKeyRef:
            name: mongo-secret # name of Secret.metadata.name
            key: mongo-root-username # Secret.data.key = mongo-root-username
      - name: MONGO_INITDB_ROOT_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mongo-secret
            key: mongo-root-password
```

**docker secrets**

```bash
kubectl create secret docker-registry dockerhub \
--docker-server=docker.io \
--docker-username=YOUR_DOCKER_HUB_USERNAME \
--docker-password=YOUR_DOCKER_HUB_PASSWORD
```

# Service

- [_https://kubernetes.io/docs/reference/kubernetes-api/service-resources/_](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/)
- [_https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/_](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)
- another type of kubernetes object.
- allows networking between pods and access outside of cluster.
- service config
  - targetPort: 8080 //tell service which port pod is listening on.
    - should match the containerPort in the 'deployment' config.
  - kubectl describe service nginx-service

**4 types of services**

- **ClusterIP** (default) sets up custom url to access pod. Only exposes pods inside the node. Sets up communication between pods in same node.
- **NodePort** means node will have one port open. Setup pods to listen on open port. Typically only used for dev purposes.
- **LoadBalancer** means a service will be exposed via an external load balancer.
- **ExternalName** Redirects an in-cluster request to a CNAME url. Used only for special purposes.

**file.yaml**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: jenkins-svc # name of Service. kubectl get service jenkins
  namespace: jenkins
spec:
  type: LoadBalancer #(ClusterIP (default), NodePort, LoadBalancer)
  selector: # Route service traffic to pods/deployment with label key:values matching this selector.
    pod: jenkins
  ports:
    - name: jenkins
      protocol: TCP
      port: 8080 # port to open on node for incoming request
      targetPort: 8080 # port to pod is listening on.
      # nodePort:  30000 # (30000-32767) Assign static NodePort. If not used, Kubernetes will automatically assign a NodePort. NodePort is a static open port on the node.
```

Internal Service -pods can talk to each other.

**Headless Service**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: jenkins # name of Service. kubectl get service jenkins
spec:
  type: None # this causes dns lookup to return pod ip addresses. For db stuff. 'None' will be listed under ip address.
```

# StatefulSet

- [_https://kubernetes.io/docs/concepts/workloads/controllers/_](https://kubernetes.io/docs/concepts/workloads/controllers/)
- [_https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/_](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/)
- [_https://kubernetes.io/docs/tasks/debug/debug-application/debug-statefulset/_](https://kubernetes.io/docs/tasks/debug/debug-application/debug-statefulset/)
- stateful apps

  - keep state in backend. protects data and state.
  - statefulset does same thing as deployment, but keeps an id on db pods, because it can't update and delete them the same way as deployment.

    - more than one db pod, one will be called master and it will be able to read and write, the others will be slaves, they can read only.

    - each pod will have it's own replica of storage (PV). all volumes must continuously synchronize data.
      - master changes data, and all slave update their own PV to keep in sync.
      - any new pod that's added will have it's own PV, then it will clone data from previous pod, then synchronize along with the others.
      - good to have persistent storage, so if pods die, data will survive.
      - when pod dies, PV gets re-attached to pod. That tells it if it's a master or slave.
      - better to have remote storage, so if pod gets moved to another node, then storage is still available.
    - pods get fixed ordered names.\$(statefulset name)-\$(ordinal) // starts at 0, then 1, then 2, ...
    - pods get own service route. (mysql-0.svc2, mysql-1.svc2)

- stateless apps
  - do not keep state, each request is completely new

# Volumes //PV & PersistentVolumeClaims PVC

- <https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/>
- <https://kubernetes.io/docs/concepts/storage/volumes/>
- <https://kubernetes.io/docs/concepts/storage/persistent-volumes/>
- attach to another source to persist data. Cloud storage, local storage
  or outside kubernetes cluster.
- PV are not namespaced. There available to all cluster.
- survive if cluster crashes.
- k8s does not track data for you.

**PersistentVolume**

- <https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes>

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```

## PersistentVolumeClaim //works with the storage class api

- <https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims>
- They are namespaced
- They claim the data and have to referenced in the deployment pod yaml.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 8Gi
  storageClassName: slow
  selector:
    matchLabels:
      release: 'stable'
    matchExpressions:
      - { key: environment, operator: In, values: [dev] }
```

## Storage Class

- <https://kubernetes.io/docs/concepts/storage/storage-classes/>
- dynamically created volumes when pvc claims it.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Retain
allowVolumeExpansion: true
mountOptions:
  - debug
volumeBindingMode: Immediate
```

**On local machine**

- <https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/>
- After you create the PersistentVolumeClaim, the Kubernetes control plane looks for a PersistentVolume that satisfies the claim's requirements. If the control plane finds a suitable PersistentVolume with the same StorageClass, it binds the claim to the volume.

```yaml
# persistent volume
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 12Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data" # sudo mkdir /mnt/data; sudo sh -c "echo 'Hello from kubernetes' > /mnt/data/index.html"

# persistentVolumeClaim
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
```
