#!/bin/bash

kubectl apply -f configmap.yaml
kubectl apply -f damonset.yaml
kubectl apply -f rbac.yaml
