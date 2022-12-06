# Skaffold

- <https://skaffold.dev/>
- <https://medium.com/containers-101/the-ultimate-guide-for-local-development-on-kubernetes-draft-vs-skaffold-vs-garden-io-26a231c71210>
- Built by google for speeding up development with kubernetes.
- watches multiple folders for changes.

```yaml
apiVersion: skaffold/v4beta1
kind: Config
metadata:
  name: blog
build:
  local:
    push: false
  artifacts:
    - image: dockerId/client
      context: client
      docker:
        dockerfile: Dockerfile
      # sync:
      #   manual:
      #     - src: 'src/**/*.ts' # when change copy directly to dest.
      #       dest: .
      #     - src: 'src/**/*.js'
      #       dest: .
      #     - src: 'src/**/*.s?css'
      #       dest: .
      # custom:
      #   buildCommand: ./build.sh client
    - image: dockerId/comments
      context: comments
      docker:
        dockerfile: Dockerfile
        buildArgs:
          PORT: '4001'
          NODE_ENV: production
      # sync:
      #   manual:
      #     - src: 'src/**/*.ts'
      #       dest: .
manifests:
  rawYaml:
    - infra/k8s/client-depl.yaml
    - infra/k8s/comments-depl.yaml
    - infra/k8s/events-depl.yaml
    # - infra/k8s/ingress-nginx.yaml # start k apply -f ingress-nginx.yaml first.
    - infra/k8s/ingress.svc.yaml
    - infra/k8s/moderation-depl.yaml
    - infra/k8s/posts-depl.yaml
    - infra/k8s/query-depl.yaml
```
