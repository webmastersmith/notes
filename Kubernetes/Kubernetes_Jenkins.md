Jenkins Kubernetes

**image**

- <https://cloud.google.com/architecture/jenkins-on-kubernetes-engine>

**Kubernetes**

- eksctl create cluster // will auto-name, and use aws config to create region
- eksctl --region us-east-1 --name my-cluster

**Install ingress-nginx-controller**

- helm install my-ingress-nginx ingress-nginx/ingress-nginx --version 4.2.0

- <https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-kubernetes>

```sh
kubectl create -f jenkins.yaml --namespace jenkins
kubectl get pods -n jenkins
kubectl logs POD-NAME -n jenkins
```

**local storage**

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: data-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 15Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: '/mnt/data/jenkins'
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jenkins-pvc
  # namespace: jenkins
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
---
# apiVersion: v1
# kind: Namespace
# metadata:
#   name: jenkins  # create namespace app.
# ---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-dev # name of deployment
  # namespace: jenkins
  labels:
    app: jenkins # key:value to reference for Service file.
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins # should match Deployment.metadata.labels.
  template:
    metadata:
      labels:
        app: jenkins # should match Deployment.metadata.labels.
    spec:
      containers:
        - resources:
            requests:
              cpu: '50m'
              memory: '256Mi'
            limits:
              cpu: '2000m'
              memory: '4096Mi'
          name: container-0 # docker container name.
          image: jenkins/jenkins@sha256:3badce57e54de38564b17ff6cc9f99d5d015ab3d1dbdf5ce005f8cd256dd15d5
          imagePullPolicy: IfNotPresent # pull local first.
          ports:
            - name: jenkins-port # name of port
              containerPort: 8080 # port app is listening on.
            - name: jnlp-port
              containerPort: 50000
          securityContext:
            allowPrivilegeEscalation: true
            privileged: true
            readOnlyRootFilesystem: false
            runAsUser: 0
          volumeMounts:
            - mountPath: /var/jenkins_home
              name: jenkins-vol # must match spec.containers.volumes.name
      volumes:
        - name: jenkins-vol
          persistentVolumeClaim:
            claimName: jenkins-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-svc
  # namespace: jenkins-dev
spec:
  type: LoadBalancer
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30000
  selector:
    app: jenkins
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-jnlp
  # namespace: jenkins-dev
spec:
  type: ClusterIP
  ports:
    - port: 50000
      targetPort: 50000
  selector:
    app: jenkins
```

**deployment.yaml** //GCP

```yaml
# apiVersion: v1
# kind: Namespace
# metadata:
#   name: jenkins  # create namespace app.
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-dev # name of deployment
  # namespace: jenkins
  labels:
    pod: jenkins # key:value to reference for Service file.
spec:
  replicas: 1
  selector:
    matchLabels:
      pod: jenkins # should match Deployment.metadata.labels.
  template:
    metadata:
      labels:
        pod: jenkins # should match Deployment.metadata.labels.
    spec:
      containers:
        - resources:
            requests:
              cpu: '50m'
              memory: '256Mi'
            limits:
              cpu: '2000m'
              memory: '4096Mi'
          name: container-0 # docker container name.
          image: jenkins/jenkins@sha256:3badce57e54de38564b17ff6cc9f99d5d015ab3d1dbdf5ce005f8cd256dd15d5
          imagePullPolicy: IfNotPresent # pull local first.
          ports:
            - name: jenkins-port # name of port
              containerPort: 8080 # port pod is listening on.
            - name: jnlp-port
              containerPort: 50000
          securityContext:
            allowPrivilegeEscalation: true
            privileged: true
            readOnlyRootFilesystem: false
            runAsUser: 0
          volumeMounts:
            - mountPath: /var/jenkins_home
              name: jenkins-vol
      volumes:
        - name: jenkins-vol
          persistentVolumeClaim:
            claimName: jenkins-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-svc
  # namespace: jenkins-dev
spec:
  type: NodePort
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30000
  selector:
    app: jenkins
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-jnlp
  # namespace: jenkins-dev
spec:
  type: ClusterIP
  ports:
    - port: 50000
      targetPort: 50000
  selector:
    app: jenkins
```

helm jenkins

```yaml
controller:
  jenkinsUriPrefix: /jenkins
  ingress:
    enabled: true
    apiVersion: 'extensions/v1'
    path: /jenkins
    annotations:
      # ingressClassName: nginx
      kubernetes.io/ingress.class: nginx
  additionalPlugins:
    - github:1.34.5
  agent:
    namespace: jenkins
```
