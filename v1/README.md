## First version of the project

This version was created since I wanted to experiment **without cloning the hextris repo.**

### V1 Info

For this version, I used the [bitnami image of apache](https://artifacthub.io/packages/helm/bitnami/apache), from [ArtifactHUB](https://artifacthub.io/) which is basically a library of Kubernetes packages. This image is tested and trusted and can be exctented with some custom params in order to include static code straight to our apache container public folder with ease.

### Steps

---
#### Helm
First what we need is to add the bitnami chart repository with the bellow command:

`helm repo add bitnami https://charts.bitnami.com/bitnami`

Next, I basically download the content of the apache bitnami image (which can also be installed with `helm install` at this point) and modified the values bellow:

Bellow we can see the values of the helm chart to use the bitnami image:

```yaml
image:
  registry: docker.io
  repository: bitnami/apache
  tag: 2.4.54-debian-11-r42
  digest: ""
```

Also, the following values have to be modified in order to download to our apache public folder our static website:

```yaml
cloneHtdocsFromGit:
  enabled: true
  repository: https://github.com/Hextris/hextris.git
  branch: gh-pages
  enableAutoRefresh: true
  interval: 60
  resources: {}
```

Also, I modified the service type to be `NodePort`, as we are just running the apache server with some static content

At this point we can run a `helm install` for our local chart and it should work perfectly if we have our **minikube** environment running. The application should be deployed to the **default** namespace.

---
#### Terraform 
For the terraform part what I did is:

1. Created the `variables.tf` file which containes shared variables for the project (could add more variables there)
2. In the `providers.tf` file I just added the kubernetes and helm providers to deploy our software to kubernetes through helm
3. Added the `helm_release_apache.tf` file which contains info about our helm chart, it's location, namespace it should run on etc.

### Running our application

In order to deploy our infra and run the app, all we have to do at this point is to navigate into the `terraform` folder and run `terraform apply`. We could also run `terraform plan` before to preview the actions of apply.

If everything is ok, we should just press **yes** in the promted and after some seconds our infra should be app and running. We could run: 
>`kubectl get nodes --namespace hextrix-namespace -o jsonpath="{.items[0].status.addresses[0].address}"` 

to see the local ip address the app is running on and:
> `kubectl get --namespace hextrix-namespace -o jsonpath="{.spec.ports[0].nodePort}" services hetrix-chart-apache`

for the port. If we navigate there we could see our app running.

Of course we can get info about our deployment with kubectl commands, such as:
* `kubectl get ns` for our ns
* `kubectl get pods -n hextrix-namespace` for our pods
* `kubectl get service -n hextrix-namespace` for our service




