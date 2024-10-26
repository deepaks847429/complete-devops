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
 