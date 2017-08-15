# APCP Kubernetes Dev Cluster - k8s-dev.gpii.net

# Requirements

 * [kops](https://github.com/kubernetes/kops)

 Follow instructions to install kops and setup necessary IAM credentials.

# Credentials

```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
```

# S3 bucket

```
export S3_BUCKET="gpii-kubernetes-dev-state-store"
export KOPS_STATE_STORE="s3://$S3_BUCKET"

aws s3api create-bucket --bucket $S3_BUCKET --region us-east-1
aws s3api put-bucket-versioning --bucket $S3_BUCKET --versioning-configuration Status=Enabled
```

# Create cluster configuration (k8s-dev.gpii.net)

 * Masters: 3
 * Node: 3
 * Instance Type: t2.medium (2 CPU, 4GB RAM)
 * Regions:
   - us-east-1a
   - us-east-1b
   - us-east-1c


Use kops alpha channel to deploy a Kubernetes cluster:

```
$ kops create cluster --kubernetes-version 1.7.3 --cloud=aws --zones us-east-1a,us-east-1b,us-east-1c --node-count 3 --master-zones us-east-1a,us-east-1b,us-east-1c --node-size t2.medium --master-size t2.medium k8s-dev.gpii.net
```

# Confirm configuration was created

```
$ kops get clusters
NAME			CLOUD	ZONES
k8s-dev.gpii.net	aws	us-east-1a,us-east-1b,us-east-1c
```

# Create cluster

```
$ kops update cluster k8s-dev.gpii.net --yes
```

# Wait 5-10min before confirming cluster is operational

```
$ kops validate cluster
Using cluster from kubectl context: k8s-dev.gpii.net

Validating cluster k8s-dev.gpii.net

INSTANCE GROUPS
NAME			ROLE	MACHINETYPE	MIN	MAX	SUBNETS
master-us-east-1a	Master	t2.medium	1	1	us-east-1a
master-us-east-1b	Master	t2.medium	1	1	us-east-1b
master-us-east-1c	Master	t2.medium	1	1	us-east-1c
nodes			Node	t2.medium	3	3	us-east-1a,us-east-1b,us-east-1c

NODE STATUS
NAME				ROLE	READY
ip-172-20-108-195.ec2.internal	node	True
ip-172-20-115-45.ec2.internal	master	True
ip-172-20-38-32.ec2.internal	master	True
ip-172-20-62-93.ec2.internal	node	True
ip-172-20-65-133.ec2.internal	master	True
ip-172-20-67-204.ec2.internal	node	True

Your cluster k8s-dev.gpii.net is ready
```

# Deploy Dashboard add-on

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.6.3.yaml
```

 * URL: <https://api.k8s-dev.gpii.net/ui>
 * User: admin
 * Password: `kops get secrets kube --type secret -oplaintext`

# Access to the cluster

People with access to the S3 bucket used by kops can generate the kubecfg configuration this way:

```
kops export kubecfg k8s-dev.gpii.net
```

You can then access the cluster API server with kubectl locally.


# Deploy GPII components

In the current configuration, the Preferences Server and Flow Manager will get exposed to the outside world through an Elastic Load Balancer each. In the future, a Kubernetes Ingress Controller should be used with a single ELB to reduce costs (or possibly a ALB Ingress Controller, if available).

## CouchDB

These steps will deploy CouchDB using the node's local storage (ephemeral). If you want data to persist, see the next section ("CouchDB with Persistent Storage")

Create CouchDB deployment and accompanying service to expose it internally to the cluster:

```
$ kubectl create -f couchdb-deploy.yml
deployment "couchdb" created

$ kubectl create -f couchdb-svc.yml
service "couchdb" created
```

Confirm deployment, pods and service were created:

```
$ kubectl get deploy couchdb
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
couchdb   1         1         1            1           1h

$ kubectl get pod -l app=couchdb
NAME                      READY     STATUS    RESTARTS   AGE
couchdb-274139905-ptzmv   1/1       Running   0          1h

$ kubectl get svc couchdb
NAME      CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
couchdb   100.70.151.178   <none>        5984/TCP   1h
```

## CouchDB with Persistent Storage

Create [PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes), CouchDB deployment and accompanying service to expose it internally to the cluster:

```
$ kubectl create -f couchdb-persistentvolumeclaim.yml
persistentvolumeclaim "couchdb-pvc" created

$ kubectl create -f couchdb-deploy-persistent.yml
deployment "couchdb" created

$ kubectl create -f couchdb-svc.yml
service "couchdb" created
```

Confirm persistent volume claim, pods and service were created:

```
$ kubectl get persistentvolumeclaim couchdb-pvc
NAME          STATUS    CAPACITY                                   ACCESS MODES   STORAGECLASS   AGE
couchdb-pvc   Bound     pvc-7884ea9c-81c0-11e7-9a77-02ad7260a0ec   5Gi            RWO            default   5m

$ kubectl get deploy couchdb
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
couchdb   1         1         1            1           5m

$ kubectl get svc couchdb
NAME      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
couchdb   ClusterIP   100.65.132.208   <none>        5984/TCP   2h
```

By using the persistent volume claim, the CouchDB deployment and pods can be deleted and re-created without losing data.

## Load Preferences Test Data

```
$ kubectl create -f dataloader-job.yml
job "couchdb-dataloader" created
```

Confirm job ran successfully at least once:

```
$ kubectl get job couchdb-dataloader
NAME                 DESIRED   SUCCESSFUL   AGE
couchdb-dataloader   1         1            1h
```


## Preferences Server (exposed externally)

```
$ kubectl create -f preferences-deploy.yml
$ kubectl create -f preferences-svc.yml
```

Confirm deployment, pods and service were created:

```
$ kubectl get deploy preferences
NAME          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
preferences   6         6         6            6           55m

$ kubectl get pod -l app=preferences
NAME                           READY     STATUS    RESTARTS   AGE
preferences-1252353590-9scv2   1/1       Running   0          46m
preferences-1252353590-h9jf0   1/1       Running   0          50m
preferences-1252353590-qw8vr   1/1       Running   0          46m
preferences-1252353590-tqgms   1/1       Running   0          56m
preferences-1252353590-v0l6p   1/1       Running   0          46m
preferences-1252353590-zn8b0   1/1       Running   0          46m

$ kubectl get svc preferences -o wide
NAME          CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)        AGE       SELECTOR
preferences   100.69.140.152   ad3d67f471f0911e791dd0ae92f5239c-263508607.us-east-1.elb.amazonaws.com   80:31323/TCP   1h        app=preferences
```

Test service:

```
$ curl http://ad3d67f471f0911e791dd0ae92f5239c-263508607.us-east-1.elb.amazonaws.com/preferences/chris
{"contexts":{"gpii-default":{"name":"Default preferences","preferences":{"http://registry.gpii.net/common/screenReaderTTSEnabled":true,"http://registry.gpii.net/common/screenReaderBrailleOutput":true,"http://registry.gpii.net/common/speechRate":350,"http://registry.gpii.net/applications/com.microsoft.windows.displaySettings":{"isActive":true},"http://registry.gpii.net/common/matchMakerType":"RuleBased"},"metadata":[{"type":"priority","scope":["http://registry.gpii.net/applications/org.nvda-project","http://registry.gpii.net/applications/es.codefactory.android.app.ma"],"value":1024}]}}}
```

## Flow Manager (exposed externally)

```
$ kubectl create -f flowmanager-deploy.yml
$ kubectl create -f flowmanager-svc.yml
```

Confirm deployment, pods and service were created:

```
$ kubectl get deploy flow-manager
NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
flow-manager   6         6         6            6           16m

$ kubectl get pod -l app=flow-manager
NAME                           READY     STATUS    RESTARTS   AGE
flow-manager-213149203-38ld7   1/1       Running   0          17m
flow-manager-213149203-4w461   1/1       Running   0          17m
flow-manager-213149203-6msqw   1/1       Running   0          17m
flow-manager-213149203-cwx14   1/1       Running   0          17m
flow-manager-213149203-svtp2   1/1       Running   0          17m
flow-manager-213149203-tx8w9   1/1       Running   0          17m

$ kubectl get svc flow-manager -o wide
NAME           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)        AGE       SELECTOR
flow-manager   100.65.105.106   a3eb37a021f1111e78718125bfe597ca-755612935.us-east-1.elb.amazonaws.com   80:30126/TCP   16m       app=flow-manager

```

Test service:

```
$ curl -v http://a3eb37a021f1111e78718125bfe597ca-755612935.us-east-1.elb.amazonaws.com/login > /dev/null
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying 54.152.173.52...
* TCP_NODELAY set
* Connected to a3eb37a021f1111e78718125bfe597ca-755612935.us-east-1.elb.amazonaws.com (54.152.173.52) port 80 (#0)
> GET /login HTTP/1.1
> Host: a3eb37a021f1111e78718125bfe597ca-755612935.us-east-1.elb.amazonaws.com
> User-Agent: curl/7.51.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< X-Powered-By: Express
< Content-Type: text/html; charset=utf-8
< Content-Length: 4773
< ETag: W/"12a5-gricBf9HK4CeEHA94WnVoA"
< Date: Wed, 12 Apr 2017 00:04:52 GMT
< Connection: keep-alive
< 
{ [2652 bytes data]
* Curl_http_done: called premature == 0
100  4773  100  4773    0     0  11670      0 --:--:-- --:--:-- --:--:-- 11698
* Connection #0 to host a3eb37a021f1111e78718125bfe597ca-755612935.us-east-1.elb.amazonaws.com left intact
```

# Terraform

To manage the cluster using Terraform, first create the cluster using the `kops create cluster` command and add the options `--out=terraform --target=terraform` at the end.

The directory [samples/terraform](samples/terraform) contains the output of the example cluster create above.

Refer to the oficial kops [documentation](https://github.com/kubernetes/kops/blob/master/docs/terraform.md) for more information on how to use it with Terraform.
