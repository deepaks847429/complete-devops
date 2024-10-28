# what is kubernetes?
- kubernetes is a container orchestration engine, which as the name suggests lets you create, delete and update container.

- a-> you have tour docker image in the docker registry and want to deploy it in a cloud native fashion.
- you want to not worry about patching, crashes. You want the system to auto heal.
- you want to autoscale with simple constructs.
- you want to observe your complete system in simple dashboard.

# nodes
- In kubernetes, you can create and connect various machines together, all of which are running kubernetes. Every machine here is known as a node.

- There are two types of nodes:-
- master node(control pane)- The node that takes care of deploying the containers/healing them/listeing to the developer to understand what to deploy.

- there are various part of control pane(internal architecture)- 
  - Api server - 
    - Handling RESTful API requests - The Api server processes and respond to restful API requests from various clients , including the kubectl command line tool, other kubernetes components and external appliactions, These requests involves creating, reading, updating and deleting kubernetes resources such as pods, services and deployments.

    - Authentication and authorization - The Api server authenticates and authorizes all API requests. It ensures that only authenticated and authorized all api requests. It ensures that only authenticated and authorized users or components can perform actions on the cluster. This involves validating user credentials and checking access control policies.

    - Metrics and health checks - The api server exposes metrices and health checks endpoints that can be used for monitoring and daignosing the health and performance of the control plane.

    - communtication hub- The Api server acts as the central communication hub for the kubernetes control plane. Other components such as the scheduler, controller manager, and kubelet, interact with the Api server to retrieve or update the state of cluster.
  - etcd
    - (distributed data store) consistent and highly available key value store used as kubernetes backing store for all cluster data.
  - kube - scheduler
    - control plane component that watches for newly created pods with no assigned node, and selects  a node for them to run on. Its resonsible for pod placement and deciding which od goes on which node.
  - kube-controller-manager 
    - The kube-controller-manager is a component of the kubernetes control plane that runs a set of controllers. Each controller is resonsible for managing a specific aspect of cluster's  state.

    There are many different types of controllers. Some examples of them are:
    - Node controller: Responsible for noticing and responding when nodes go down.
    - Deployment controller:  Watches for newly created or updated deployments and manages the creation and updating of ReplicaSets based on the deployment specifications. It ensures that the desired state of the deployment is maintained by creating or scaling ReplicaSets as needed.
    - ReplicaSet Controller: Watches for newly created or updated ReplicaSets and ensures that the desired number of pod replicas are running at any given time. It creates or deletes pods as necessary to maintain the specified number of replicas in the ReplicaSet's configuration.
- worker nodes- the nodes that actually run your backend/frontend.
    - kubelet 
     - An agent that runs on each node in the cluster. It makes sure that containers are running in a Pod.
    - kube- proxy - The kube-proxy is a network proxy that runs on each node in a Kubernetes cluster. It is responsible for you being able to talk to a pod
    - container - runtime 
     - in a kubernetes worker node, the container runtime is the software responsible for running containers.


# Cluster

- A bunch of worker nodes+master nodes make up your kubernetes cluster. You can always add more/remove nodes from a cluster.

# Pods
- A pod is the smallest and simplest unit in kubernetes object model that you can create or deploy.
- A single pod can run multiple container.

# images
A docker image is a lightweight, standalone and executable software package that includes everything needed to run a piece of software, including the code, runtime, liabraries, environment variable, and configuration files. Images are built from a set of instructions defined in a file called a dockerfile.

- cluster->node->pods->container->docker images

# single node setup
- creat a 1 node cluster(kind create cluster --name local)
- Check the docker containers you have running(docker ps)
- Delete the cluster(kind delete cluster -n local)

# multinode setup
- Create a clusters.yml file
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
role: control-plane
role: worker
role: worker
- Create the node setup(kind create cluster --config clusters.yml --name local)
- Check docker containers(docker ps)

- Kubernetes API server does authentication checks and prevents you from getting in.
All of your authorization credentials are stored by kind in ~/.kube/config 

# kubectl
- kubectl is a command-line tool for interacting with Kubernetes clusters. It provides a way to communicate with the Kubernetes API server and manage Kubernetes resources.

 - basic commands
 kubectl get nodes
 kubectl get pods
 kubectl get nodes --v=8

 - We have created a cluster of 3 nodes
 How can we deploy a single container from an image  inside a pod ?

 # Starting a pod using k8s
 - kubectl run nginx --image=nginx --port=80(start a pod)
 - kubectl get pods(check status of pods)
 - kubectl logs nginx(check the logs)
 - kubectl delete pod nginx(stop the pod)

# Kubernetes manifest
- A manifest defines the desired state for Kubernetes resources, such as Pods, Deployments, Services, etc., in a declarative manner. 

- Mainifest 
   apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80

- applying the maifest(kubectl apply -f manifest.yml)
- Delete the pod (kubectl delete pod nginx)

# Deployment 
- A Deployment in Kubernetes is a higher-level abstraction that manages a set of Pods and provides declarative updates to them. It offers features like scaling, rolling updates, and rollback capabilities, making it easier to manage the lifecycle of applications.

- Pod: A Pod is the smallest and simplest Kubernetes object. It represents a single instance of a running process in your cluster, typically containing one or more containers.

- Deployment: A Deployment is a higher-level controller that manages a set of identical Pods. It ensures the desired number of Pods are running and provides declarative updates to the Pods it manages.

- Abstraction Level:
 - Pod: A Pod is the smallest and simplest Kubernetes object. It represents a single instance of a running process in your cluster, typically containing one or more containers.
 - Deployment: A Deployment is a higher-level controller that manages a set of identical Pods. It ensures the desired number of Pods are running and provides declarative updates to the Pods it manages.


- Management:
  - Pod: They are ephemeral, meaning they can be created and destroyed frequently.
  - Deployment: Deployments manage Pods by ensuring the specified number of replicas are running at any given time. If a Pod fails, the Deployment controller replaces it automatically.

- Updates:
Pod: Directly updating a Pod requires manual intervention and can lead to downtime.
Deployment: Supports rolling updates, allowing you to update the Pod template (e.g., new container image) and roll out changes gradually. If something goes wrong, you can roll back to a previous version.

- Scaling:
Pod: Scaling Pods manually involves creating or deleting individual Pods.
Deployment: Allows easy scaling by specifying the desired number of replicas. The Deployment controller adjusts the number of Pods automatically.
- Self-Healing:
Pod: If a Pod crashes, it needs to be restarted manually unless managed by a higher-level controller like a Deployment.
Deployment: Automatically replaces failed Pods, ensuring the desired state is maintained.

# Replicaset
A ReplicaSet in Kubernetes is a controller that ensures a specified number of pod replicas are running at any given time. It is used to maintain a stable set of replica Pods running in the cluster, even if some Pods fail or are deleted.
 
When you create a deployment, you mention the amount of replicas you want for this specific pod to run. The deployment then creates a new ReplicaSet that is responsible for creating X number of pods.

# Series of events
User creates a deployment which creates a replicaset which creates pods
If pods go down, replicaset controller  ensures to bring them back up.

# series of event in detail
- Series of events
When you run the following command, a bunch of things happen
- kubectl create deployment nginx-deployment --image=nginx --port=80 --replicas=3

Step-by-Step Breakdown:
- Command Execution:
You execute the command on a machine with kubectl installed and configured to interact with your Kubernetes cluster.
- API Request:
kubectl sends a request to the Kubernetes API server to create a Deployment resource with the specified parameters.
- API Server Processing:
The API server receives the request, validates it, and then processes it. If the request is valid, the API server updates the desired state of the cluster stored in etcd. The desired state now includes the new Deployment resource.
- Storage in etcd:
The Deployment definition is stored in etcd, the distributed key-value store used by Kubernetes to store all its configuration data and cluster state. etcd is the source of truth for the cluster's desired state.
- Deployment Controller Monitoring:
The Deployment controller, which is part of the kube-controller-manager, continuously watches the API server for changes to Deployments. It detects the new Deployment you created.
- ReplicaSet Creation:
The Deployment controller creates a ReplicaSet based on the Deployment's specification. The ReplicaSet is responsible for maintaining a stable set of replica Pods running at any given time.
Pod Creation:
- The ReplicaSet controller (another part of the kube-controller-manager) ensures that the desired number of Pods (in this case, 3) are created and running. It sends requests to the API server to create these Pods.
- Scheduler Assignment:
The Kubernetes scheduler watches for new Pods that are in the "Pending" state. It assigns these Pods to suitable nodes in the cluster based on available resources and scheduling policies.
- Node and Kubelet:
The kubelet on the selected nodes receives the Pod specifications from the API server. It then pulls the necessary container images (nginx in this case) and starts the containers.
 
 # hierarchial relationship
 Hierarchical Relationship
- Deployment:
High-Level Manager: A Deployment is a higher-level controller that manages the entire lifecycle of an application, including updates, scaling, and rollbacks.
Creates and Manages ReplicaSets: When you create or update a Deployment, it creates or updates ReplicaSets to reflect the desired state of your application.
Handles Rolling Updates and Rollbacks: Deployments handle the complexity of updating applications by managing the creation of new ReplicaSets and scaling down old ones.
- ReplicaSet:
Mid-Level Manager: A ReplicaSet ensures that a specified number of identical Pods are running at any given time.
Maintains Desired State of Pods: It creates and deletes Pods as needed to maintain the desired number of replicas.
Label Selector: Uses label selectors to identify and manage Pods.
- Pods:
Lowest-Level Unit: A Pod is the smallest and simplest Kubernetes object. It represents a single instance of a running process in your cluster and typically contains one or more containers.
 

 # Role of deployment
Deployment ensures that there is a smooth deployment, and if the new image fails for some reason, the old replicaset is maintained.
Even though the rs is what does pod management , deployment is what does rs management

# services

In Kubernetes, a "Service" is an abstraction that defines a logical set of Pods and a policy by which to access them. Kubernetes Services provide a way to expose applications running on a set of Pods as network services. Here are the key points about Services in Kubernetes:

Key concepts
- Pod Selector: Services use labels to select the Pods they target. A label selector identifies a set of Pods based on their labels.
Service Types:
- ClusterIP: Exposes the Service on an internal IP in the cluster. This is the default ServiceType. The Service is only accessible within the cluster.
- NodePort: Exposes the Service on each Node’s IP at a static port (the NodePort). A ClusterIP Service, to which the NodePort Service routes, is automatically created. You can contact the NodePort Service, from outside the cluster, by requesting <NodeIP>:<NodePort>.
- LoadBalancer: Exposes the Service externally using a cloud provider’s load balancer. NodePort and ClusterIP Services, to which the external load balancer routes, are automatically created.
- Endpoints: These are automatically created and updated by Kubernetes when the Pods selected by a Service's selector change.

# Loadbalancer service 

In Kubernetes, a LoadBalancer service type is a way to expose a service to external clients. When you create a Service of type LoadBalancer, Kubernetes will automatically provision an external load balancer from your cloud provider (e.g., AWS, Google Cloud, Azure) to route traffic to your Kubernetes service

# Downsides of services
Services are great, but they have some downsides - 
- Scaling to multiple apps
- If you have three apps (frontend, backend, websocket server), you will have to create 3 saparate services to route traffic to them. There is no way to do centralized traffic management (routing traffic from the same URL/Path-Based Routing) 
- There are also limits to how many load balancers you can create

- Multiple certificates for every route
You can create certificates for your load balancers but you have to maintain them outside the cluster and create them manually
You also have to update them if they ever expire
 
- No centralized logic to handle rate limitting to all services
Each load balancer can have its own set of rate limits, but you cant create a single rate limitter for all your services. 
# ingress
Ingress in Kubernetes is a critical component for managing external access to services within a Kubernetes cluster. It plays a key role in defining rules that allow external traffic to reach internal services, ensuring secure and controlled access. Here’s why Ingress is important:

1. Simplifies External Access to Services
Kubernetes services are internally accessible within a cluster by default, but external access needs configuration. Ingress provides a way to route external HTTP(S) requests to specific services within the cluster, making it easier to manage how external users interact with applications running on Kubernetes.
2. Centralized Traffic Management
Ingress acts as a single point of entry for all external requests, centralizing the management of routes. It allows administrators to set up routing rules based on paths, hostnames, and other request attributes. This avoids the need for complex load balancer configurations on each service and consolidates routing in one place.
3. Enables Load Balancing
Ingress controllers handle load balancing, distributing traffic across multiple instances of a service. This helps improve the scalability and reliability of applications by ensuring that no single pod is overwhelmed by traffic, enhancing overall performance.
4. SSL Termination for Security
Ingress can handle SSL/TLS termination, meaning it can decrypt incoming HTTPS traffic before routing it within the cluster. This allows for secure connections from clients without requiring each service to manage its own SSL certificates, streamlining security management.
5. Supports Path-Based Routing
With Ingress, you can route traffic based on URL paths. For instance, requests to /api could be directed to an API service, while /web could go to a web front-end service. This enables efficient microservices architectures, where multiple services can coexist under a single domain, each serving different functionality.
6. Enables Host-Based Routing
Ingress allows routing based on hostnames, so different services can be exposed under unique subdomains. For instance, api.example.com and web.example.com can be routed to different services within the same cluster, enhancing service isolation and organization.
7. Reduces Load Balancer Costs
Without Ingress, you might need a separate load balancer for each service, which can be costly and complex to maintain. Ingress uses a single load balancer to route traffic to multiple services, reducing both operational costs and infrastructure complexity.
8. Advanced Features via Ingress Controllers
Kubernetes Ingress is implemented through Ingress controllers, such as NGINX, Traefik, or Istio, which provide advanced features like rate limiting, authentication, custom error pages, and caching. This flexibility allows Ingress to be tailored to the unique needs of your applications and security policies.
Overall, Ingress is a powerful Kubernetes resource that simplifies external traffic management, enhances security, improves scalability, and enables cost-effective routing to services, making it a fundamental component in production-grade Kubernetes environments.

# Ingress controller
If you remember from last week, our control plane had a controller manager running.
- The kube-controller-manager runs a bunch of controllers like
Replicaset controller
Deployment controller
etc
If you want to add an ingress to your kubernetes cluster, you need to install an ingress controller manually. It doesn’t come by default in k8s
Famous k8s ingress controllers
The NGINX Ingress Controller for Kubernetes works with the NGINX webserver (as a proxy).
HAProxy Ingress is an ingress controller for HAProxy.
The Traefik Kubernetes Ingress provider is an ingress controller for the Traefik proxy.
Full list - https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/
 
 # Namespaces
In Kubernetes, a namespace is a way to divide cluster resources between multiple users/teams. Namespaces are intended for use in environments with many users spread across multiple teams, or projects, or environments like development, staging, and production.
When you do # NamespaCES 
# secrets and configmaps
-  Kubernetes suggests some standard configuration practises.
These include things like
You should always create a deployment rather than creating naked pods
Write your configuration files using YAML rather than JSON
Configuration files should be stored in version control before being pushed to the cluster
 
Kubernetes v1 API also gives you a way to store configuration of your application outside the image/pod
This is done using 
ConfigMaps 
Secrets
Rule of thumb
Don’t bake your application secrets in your docker image
Pass them in as environment variables whenever you’re starting the container.

# configmap
A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.
A ConfigMap allows you to decouple environment-specific configuration from your container images, so that your applications are easily portable.

# secrets
-Secrets
Secrets are also part of the kubernetes v1 api. They let you store passwords / sensitive data which can then be mounted on to pods as environment variables. Using a Secret means that you don't need to include confidential data in your application code.
Ref - https://kubernetes.io/docs/concepts/configuration/secret/
Using a secret
Create the manifest with a secret and pod (secret value is base64 encoded) (https://www.base64encode.org/)

# config vs secrets
Key differences
Purpose and Usage:
Secrets: Designed specifically to store sensitive data such as passwords, OAuth tokens, and SSH keys.
ConfigMaps: Used to store non-sensitive configuration data, such as configuration files, environment variables, or command-line arguments.
Base64 Encoding:
Secrets: The data stored in Secrets is base64 encoded. This is not encryption but simply encoding, making it slightly obfuscated. This encoding allows the data to be safely transmitted as part of JSON or YAML files.
ConfigMaps: Data in ConfigMaps is stored as plain text without any encoding.
Volatility and Updates:
Secrets: Often, the data in Secrets needs to be rotated or updated more frequently due to its sensitive nature.
ConfigMaps: Configuration data typically changes less frequently compared to sensitive data.
Kubernetes Features:
Secrets: Kubernetes provides integration with external secret management systems and supports encryption at rest for Secrets when configured properly. Ref https://secrets-store-csi-driver.sigs.k8s.io/concepts.html#provider-for-the-secrets-store-csi-driver
ConfigMaps: While ConfigMaps are used to inject configuration data into pods, they do not have the same level of support for external management and encryption.

# volumes in kubernetes
- Volumes in kubernetes
Ref - https://kubernetes.io/docs/concepts/storage/volumes/
Volumes
In Kubernetes, a Volume is a directory, possibly with some data in it, which is accessible to a Container as part of its filesystem. Kubernetes supports a variety of volume types, such as EmptyDir, PersistentVolumeClaim, Secret, ConfigMap, and others.
Why do you need volumes?
If two containers in the same pod want to share data/fs.
- If you want to create a database that persists data even when a container restarts (creating a DB)
-Your pod just needs extra space during execution (for caching lets say) but doesnt care if it persists or not.

# types of volumes
- Types of volumes
Ephemeral Volume
Temporary volume that can be shared amongst various containers of a pod.  When the pods dies, the volume dies with it.
For example - 
ConfigMap
Secret
emptyDir
Persistent Volume
A Persistent Volume (PV) is a piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using Storage Classes. It is a resource in the cluster just like a node is a cluster resource. PVs are volume plugins like Volumes but have a lifecycle independent of any individual Pod that uses the PV. This API object captures the details of the implementation of the storage, be that NFS, iSCSI, or a cloud-provider-specific storage system.
Persistent volume claim
A Persistent Volume Claim (PVC) is a request for storage by a user. It is similar to a Pod. Pods consume node resources and PVCs consume PV resources. Pods can request specific levels of resources (CPU and Memory). Claims can request specific size and access modes (e.g., can be mounted once read/write or many times read-only).

# persistent volumes
Persistent volumes
Just like our kubernetes cluster has nodes where we provision our pods.
We can create peristent volumes where our pods can claim (ask for) storage 
# static persistent volumes
- Static persistent volumes
Creating a NFS
NFS is one famous implementation you can use to deploy your own persistent volume
I’m running one on my aws server - 