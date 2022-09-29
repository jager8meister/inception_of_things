path_conf=/home/roberto/Desktop/42/iot_rosa/p3/confs
k3d cluster create iot-cluster -p 8080:80@loadbalancer
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f $path_conf/argo.yaml
sleep 10
kubectl wait --for=condition=Ready pods --all --timeout=-1s -n argocd
kubectl apply -n argocd -f $path_conf/ingress.yaml
passwordsecret=$(kubectl get secret argocd-initial-admin-secret -n argocd -o yaml | grep "password: " | cut -b 13-)
password=$(echo $passwordsecret | base64 --decode)
kubectl apply -f $path_conf/application.yaml -n argocd
kubectl apply -f $path_conf/project.yaml -n argocd