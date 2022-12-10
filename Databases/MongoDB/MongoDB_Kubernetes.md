# MongoDb Kubernetes

**mongo-depl.yaml**

- makes sure no cpu/memory limits.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo-depl # the name kubernetes shows you: kubectl get pods
  labels:
    app: mongo # name of pod
spec:
  replicas: 1
  selector: # how to find pods to manage.
    matchLabels: # looks at key:value pair. 'app:mongo' both have to match.
      app: mongo # label of pod (spec.template.metadata.labels.app) you want replicas of.
  template: # how kubernetes should create the pod.
    metadata:
      labels:
        app: mongo # all replicas label with 'app:mongo'.
    spec:
      containers:
        - name: mongo # name of container
          imagePullPolicy: IfNotPresent # Never
          image: mongo # name of local/docker hub image.
          env:
            - name: MONGO_INITDB_ROOT_USERNAME
              value: root
            - name: MONGO_INITDB_ROOT_PASSWORD
              value: password
          # ports:
          # - containerPort: 4001 # connect pod port 4000 to nodePort.
---
apiVersion: v1
kind: Service
metadata:
  name: mongo-svc # kubectl get service post-svc
  # namespace: jenkins
spec:
  # type: ClusterIP #(ClusterIP (default), NodePort, LoadBalancer)
  type: ClusterIP #(ClusterIP (default), NodePort, LoadBalancer)
  selector: # Route service traffic to deployment with label key:values matching this selector.
    app: mongo
  ports:
    - name: mongo
      protocol: TCP
      port: 27017 # port to open on node for incoming request
      targetPort: 27017 # port to pod is listening on.
```

**skaffold.yaml**

- no need to make a route. only visible to inner cluster.

```yaml
manifests:
  rawYaml:
    - infra/k8s/mongo-depl.yaml
```
