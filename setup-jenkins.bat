@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

echo ==========================================================
echo    🚀 Starting Jenkins + Kubernetes setup on Windows
echo ==========================================================

:: Step 1: Start Minikube with Docker driver
echo.
echo 🟡 Starting Minikube...
minikube start --driver=docker

:: Step 2: Check Minikube status
echo.
echo 🔍 Checking Minikube status...
minikube status

:: Step 3: Add Jenkins Helm repo
echo.
echo ➕ Adding Helm repo for Jenkins...
helm repo add jenkins https://charts.jenkins.io
helm repo update

:: Step 4: Create Jenkins namespace
echo.
echo 🗂️ Creating 'jenkins' namespace (if not exists)...
kubectl create namespace jenkins 2>NUL || echo Namespace already exists.

:: Step 5: Install Jenkins using Helm
echo.
echo 📦 Installing Jenkins Helm chart...
helm install jenkins jenkins/jenkins -n jenkins -f jenkins-values.yaml

:: Step 6: Wait for Jenkins to be ready
echo.
echo ⏳ Waiting for Jenkins pod to be ready...
kubectl wait --namespace jenkins --for=condition=ready pod --selector=app.kubernetes.io/component=jenkins-controller --timeout=300s

:: Step 7: Show Jenkins service info
echo.
echo 🌐 Getting Jenkins service info...
minikube service jenkins -n jenkins

echo.
echo ✅ Jenkins should now be accessible. Keep this terminal open while Jenkins is running.

ENDLOCAL
pause
