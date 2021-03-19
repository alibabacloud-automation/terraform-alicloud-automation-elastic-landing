# Create a kustomize app from a Git repo

## Create a directory app
```bash
$ kubectl create ns demo-kustomize
$ appcenter app create --name demo-kustomize --repo https://github.com/haoshuwei/appcenter-samples.git --revision latest --path examples/demo-kustomize --dest-namespace demo-kustomize --dest-server https://kubernetes.default.svc
$ appcenter app sync demo-kustomize
```

## supported parameters

- `--sync-policy`

    Set the sync policy (one of: automated, none)
    
- `--revision-history-limit`

    How many items to keep in revision history (default 10)
    
- `--nameprefix`

    Kustomize nameprefix
    
- `--namesuffix`

    Kustomize namesuffix