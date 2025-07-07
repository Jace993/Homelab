kubectl apply -f pod.yml
kubectl logs -f nginx-example
kubectl get pods -o wide
kubectl get service

kubectl delete pod 
kubectl delete pods --all

kubectl describe pod 

kubeadm token create --print-join-command
kuectl logs -f app