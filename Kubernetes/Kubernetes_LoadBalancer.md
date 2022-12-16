Kubernetes LoadBalancer

aws

- <https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/how-it-works/>

nginx

- api

  - <https://kubernetes.github.io/ingress-nginx/#faq-migration-to-apiversion-networkingk8siov1>
  -

# Windows Hosts file

- "C:\Windows\System32\drivers\etc\hosts"
  - `127.0.0.1 posts.com`

# Setup

1. get ingress controller and create yaml 'ingress-nginx.yaml' or directly from helm.
   1. <https://kubernetes.github.io/ingress-nginx/>
   2. <https://github.com/kubernetes/ingress-nginx>
2. `kubectl apply -f ingress-nginx.yaml`
3. create routes: `ingress-srv.yaml`

**ingress-srv.yaml**

```yaml
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
          - path: /api/v[0-9]{1,3}/users/.+
            pathType: Prefix
            backend:
              service:
                name: auth-srv
                port:
                  number: 4000
          # - path: /api/v[0-9]{1,3}/db/.*
          #   pathType: Prefix
          #   backend:
          #     service:
          #       name: mongo-srv
          #       port:
          #         number: 27017
          # - path: /posts/?(.*)/comments # regex
          #   pathType: Prefix
          #   backend:
          #     service:
          #       name: comments-srv
          #       port:
          #         number: 4001
          # - path: /query
          #   pathType: Prefix
          #   backend:
          #     service:
          #       name: query-srv
          #       port:
          #         number: 4002
          # - path: /moderation
          #   pathType: Prefix
          #   backend:
          #     service:
          #       name: moderation-srv
          #       port:
          #         number: 4003
          # - path: /events
          #   pathType: Prefix
          #   backend:
          #     service:
          #       name: events-srv
          #       port:
          #         number: 4005
          # - path: /?(.*) # regex match all routes. must be at the bottom or routes.
          #   pathType: Prefix
          #   backend:
          #     service:
          #       name: client-srv
          #       port:
          #         number: 80
```
