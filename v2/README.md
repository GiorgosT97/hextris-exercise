## Second version of the project

This version was created to show how we can deploy our app, after **containarizing** it.

### V2 Info

For this version, I cloned the application and added a `Dockerfile`. I used nginx, built the image and uploaded the container to **dockerhub**. Then I created the same terraform files and pointed the image repo to my public dockerhub container. Apart from that, it's the same as the first version.

### Steps

---
#### Docker
First what we need is to clone our [repo](https://github.com/Hextris/hextris/tree/gh-pages) and add on the top level of the repo a the `Dockerfile`, which is very small and contains the following info:

```
FROM nginx:alpine

COPY . usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```
What we do here is basically create a nginx container and move our static content to the public nginx folder. Also we expose the port 80 and run the nginx server.

At this point we can run a `docker build` and `run` to check if everything is ok and then tag the container and `docker push` our container to dockerhub (or any other public container repo we want).

---
#### Helm
Then we create the helm chart with `helm create`, which needs only `deployment`, `service` and `service account` templates and we change the values to point to our repository. Bellow we can see the values (I named the container **hextrix-app**, its tag is **v1** and **bitleaf** is the name of the account I use on dockerhub):

```yaml
image:
  repository: bitleaf/hextris-app
  pullPolicy: IfNotPresent
  tag: v1
```

Also, I modified the service type to be `NodePort`, as we are just running the nginx server with some static content

At this point we can run a `helm install` for our local chart and it should work perfectly if we have our **minikube** environment running. The application should be deployed to the **default** namespace.

---
#### Terraform 
For the terraform part is excactly the same:

1. Created the `variables.tf` file which containes shared variables for the project (could add more variables there)
2. In the `providers.tf` file I just added the kubernetes and helm providers to deploy our software to kubernetes through helm
3. Added the `helm_release_apache.tf` file which contains info about our helm chart, it's location, namespace it should run on etc.

### Running our application

In order to deploy our infra and run the app, all we have to do at this point is to navigate into the `terraform` folder and run `terraform apply`. We could also run `terraform plan` before to preview the actions of apply.

If everything is ok, we should just press **yes** in the promted and after some seconds our infra should be app and running. We could run: 
>`kubectl get nodes --namespace hextrix-namespace -o jsonpath="{.items[0].status.addresses[0].address}"` 

to see the local ip address the app is running on and:
> `kubectl get --namespace hextrix-namespace -o jsonpath="{.spec.ports[0].nodePort}" services hextris-chart`

for the port. If we navigate there we could see our app running.

Of course we can get info about our deployment with kubectl commands, such as:
* `kubectl get ns` for our ns
* `kubectl get pods -n hextrix-namespace` for our pods
* `kubectl get service -n hextrix-namespace` for our service




