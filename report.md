# Decision report

## 1. Step
For this I decided to go with node.js for the sole reason that I have the most experience with using it and setting up apps. Why luxon for the time/clock, just found an easiest/quickest to setup library for that. For the Dockerfile we just use the most lightweight node.js image as a base to build on top. We create a non root user to run the app and we have a 2 step build process build/run. 

## 2. Step
For the Kubernetes cluster we deploy locally, decided to go for minikube, probably should of went with k3s cause it's more lightweight but went with the latter caused I've set it up before. For the actual manifests we simple just have a deployment specification were we run the app as non root and use our dockerhub deployed image. As for ingress we deploy a very simple setup with ClusterIP to locally access it with port forward on port 80. 

## 3. Step
For CI/CD went with Github actions, just because I wanted to try them and also I could use their self hosted runner to run the actual pipeline execution locally so the cluster isn't exposed to the internet which simplifies the setup. Only secrets we store is the auth for dockerhub to push the created image and then we apply the manifests in the next stage on the cluster. 

## 4. Step 

For this just decided to go with a shell script because using Ansible would just make it more complex for no reason especially for a homework task. Here we just install latest dependencies, install docker, kubectl, minikube, start the cluster. Though if using WSL, might need Docker Engine installed beforehand.


## 5. step
As for scaling the app most simple way would be increase the amount of replicas so more pods or the other way would be using Horizontal Pod Autoscaler based on load. 
For security as I said we run as non root where possible, and we can obviously restrict more like network traffic origin and so on and add TLS. 
