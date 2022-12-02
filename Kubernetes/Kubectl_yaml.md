# Kubernetes Yaml Examples

## Pod

- https://kubernetes.io/docs/concepts/workloads/pods/
- usually don't create pods this way. Use deployments
- kubernetes will not automatically manage pods created this way.
- when pod dies, will not be re-created.

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

## Deployment

- <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>
- describes pods and tells kubernetes to manage pods.
- pods created from deployment, will automatically be re-created when they die.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: posts-depl # the name kubernetes shows you: kubectl get pods
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
```
