# 

kubectl apply -f redis.yaml 
secret/redis-secret created
pod/redis created
service/redis-database created

kubectl get all
NAME        READY   STATUS    RESTARTS   AGE
pod/redis   1/1     Running   0          37s

NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/kubernetes       ClusterIP   10.132.0.1      <none>        443/TCP    19m
service/redis-database   ClusterIP   10.132.167.86   <none>        6379/TCP   37s

kubectl apply -f throttler.yaml 
deployment.apps/throttler-app created
service/throttler-app created

kubectl get all
NAME                                 READY   STATUS    RESTARTS   AGE
pod/redis                            1/1     Running   0          5m31s
pod/throttler-app-5df8799474-xkvb2   1/1     Running   0          33s

NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/kubernetes       ClusterIP   10.132.0.1      <none>        443/TCP    24m
service/redis-database   ClusterIP   10.132.167.86   <none>        6379/TCP   5m31s
service/throttler-app    ClusterIP   10.132.71.240   <none>        8080/TCP   33s

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/throttler-app   1/1     1            1           33s

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/throttler-app-5df8799474   1         1         1       33s

###

kubectl apply -f amqp.yaml 
secret/amqp-secret created
pod/rabbitmq created
service/rabbitmq-proxy created

kubectl apply -f pubsub.yaml 
secret/pubsub-secret created
pod/zookeeper-node created
service/zookeeper-node created
pod/kafka-node created
service/kafka-node created

kubectl apply -f db.yaml 
secret/db-secret created
job.batch/postgres-setup-job created
pod/postgres-database created
service/postgres-database created

########

git clone https://github.com/hasAnybodySeenHarry/expenses.git
Cloning into 'expenses'...
remote: Enumerating objects: 1094, done.
remote: Counting objects: 100% (145/145), done.
remote: Compressing objects: 100% (115/115), done.
remote: Total 1094 (delta 72), reused 88 (delta 27), pack-reused 949 (from 2)
Receiving objects: 100% (1094/1094), 299.92 KiB | 1.15 MiB/s, done.
Resolving deltas: 100% (506/506), done.


docker build -t mrnanda/expenses:0.0.1 .

docker login 

docker push mrnanda/expenses:0.0.1

###

kubectl apply -f expenses.yaml 
deployment.apps/expenses-app created
service/expenses-app created

#####

kubectl rollout restart deployment.apps/throttler-app

######

kubectl apply -f mongo.yaml 
secret/mongo-secret created
pod/mongo-db created
service/mongo-database created

######

docker build -t mrnanda/notifier:0.0.1 .

docker login 

docker push mrnanda/notifier:0.0.1 

#####

kubectl apply -f notifier.yaml 
deployment.apps/notifier-app created
service/notifier-app created

######

docker build -t mrnanda/mailer:0.0.1 .

docker login 

docker push mrnanda/mailer:0.0.1

######

kubectl apply -f mailer.yaml 
deployment.apps/mailer-app created
service/mailer-app created

######

kubectl get all
NAME                                 READY   STATUS    RESTARTS   AGE
pod/expenses-app-b7fdffd96-2v559     1/1     Running   0          50m
pod/kafka-node                       1/1     Running   0          87m
pod/mailer-app-66cdc6cd59-8bt7b      1/1     Running   0          57s
pod/mongo-db                         1/1     Running   0          26m
pod/notifier-app-7d8d6fddfd-2dzpq    1/1     Running   0          10m
pod/postgres-database                1/1     Running   0          66m
pod/rabbitmq                         1/1     Running   0          101m
pod/redis                            1/1     Running   0          125m
pod/throttler-app-78757784bc-t6rgs   1/1     Running   0          34m
pod/zookeeper-node                   1/1     Running   0          87m

NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                        AGE
service/expenses-app        ClusterIP   10.132.106.95    <none>        8080/TCP,50051/TCP             50m
service/kafka-node          ClusterIP   10.132.247.72    <none>        9092/TCP,9093/TCP              87m
service/kubernetes          ClusterIP   10.132.0.1       <none>        443/TCP                        144m
service/mailer-app          ClusterIP   10.132.176.19    <none>        8080/TCP                       57s
service/mongo-database      ClusterIP   10.132.144.206   <none>        27017/TCP                      26m
service/notifier-app        ClusterIP   10.132.115.155   <none>        8080/TCP                       10m
service/postgres-database   ClusterIP   10.132.123.247   <none>        5432/TCP                       66m
service/rabbitmq-proxy      ClusterIP   10.132.66.134    <none>        5672/TCP,15672/TCP,15692/TCP   101m
service/redis-database      ClusterIP   10.132.167.86    <none>        6379/TCP                       125m
service/throttler-app       ClusterIP   10.132.71.240    <none>        8080/TCP                       121m
service/zookeeper-node      ClusterIP   10.132.126.10    <none>        2181/TCP                       87m

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/expenses-app    1/1     1            1           50m
deployment.apps/mailer-app      1/1     1            1           57s
deployment.apps/notifier-app    1/1     1            1           10m
deployment.apps/throttler-app   1/1     1            1           121m

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/expenses-app-b7fdffd96     1         1         1       50m
replicaset.apps/mailer-app-66cdc6cd59      1         1         1       57s
replicaset.apps/notifier-app-7d8d6fddfd    1         1         1       10m
replicaset.apps/throttler-app-5df8799474   0         0         0       121m
replicaset.apps/throttler-app-78757784bc   1         1         1       34m
replicaset.apps/throttler-app-78df58446d   0         0         0       46m

#### install ingress controller 

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

#####

helm upgrade -i nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.admissionWebhooks.enabled=false \
  --set controller.allowSnippetAnnotations=true 

######

kubectl logs -n ingress-nginx nginx-ingress-ingress-nginx-controller-7ff7d99ff4-sx69z

E0717 01:04:19.904232      14 store.go:941] annotation group ServerSnippet contains risky annotation based on ingress configuration

######

kubectl get configmap -n ingress-nginx
NAME                                     DATA   AGE
kube-root-ca.crt                         1      9h
nginx-ingress-ingress-nginx-controller   1      7m34s

######

kubectl edit configmap nginx-ingress-ingress-nginx-controller -n ingress-nginx

apiVersion: v1
data:
  allow-snippet-annotations: "true"
  annotations-risk-level: Critical  # add this line
kind: ConfigMap

#####

kubectl rollout restart deployment/nginx-ingress-ingress-nginx-controller -n ingress-nginx
deployment.apps/nginx-ingress-ingress-nginx-controller restarted

#####

kubectl get all

NAME                                                          READY   STATUS    RESTARTS   AGE
pod/nginx-ingress-ingress-nginx-controller-659cb6b598-fjgt7   1/1     Running   0          9m29s

NAME                                             TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)                      AGE
service/nginx-ingress-ingress-nginx-controller   LoadBalancer   10.132.235.249   172.18.255.180   80:31967/TCP,443:30378/TCP   11m

NAME                                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-ingress-ingress-nginx-controller   1/1     1            1           11m

NAME                                                                DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-ingress-ingress-nginx-controller-659cb6b598   1         1         1       9m29s
replicaset.apps/nginx-ingress-ingress-nginx-controller-7ff7d99ff4   0         0         0       11m

#####

kubectl apply -f unsecure-ingress.yaml

######

kubectl get ingress
NAME                CLASS   HOSTS   ADDRESS          PORTS   AGE
flextrack-ingress   nginx   *       172.18.255.180   80      28m

##### call to expenses services

curl http://172.18.255.180/expenses/v1/healthcheck
{"status":true,"time":"2025-07-19T10:31:45.400290404Z"}

#### call to notifier services

curl http://172.18.255.180/notifier/v1/healthcheck
{"status":true,"time":"2025-07-19T10:32:23.325212518Z"}
