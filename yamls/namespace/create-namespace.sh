#!/bin/bash

## Namespace 생성
kubectl create namespace a
kubectl create namespace b

## 현재 디렉토리) a namespace에 생성
kubectl apply -f . -n a

## 현재 디렉토리) b namespace에 생성
kubectl apply -f . -n b

## 그냥 Default Namespace에 nginx 생성
kubectl apply -f default-nginx.yaml
