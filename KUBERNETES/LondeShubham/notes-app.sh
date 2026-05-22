#!/bin/bash

set -e

# ─────────────────────────────────────────────
# Config
# ─────────────────────────────────────────────
REPO_URL="https://github.com/Dev00333/django-notes-app"
CLONE_DIR="$HOME/k8s/projects/django-notes-app"
K8S_DIR="$CLONE_DIR/k8s"

# ─────────────────────────────────────────────
# Colors
# ─────────────────────────────────────────────
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}   Django Notes App - K8s Setup Script  ${NC}"
echo -e "${CYAN}========================================${NC}"

# ─────────────────────────────────────────────
# Step 1: Clone the repo
# ─────────────────────────────────────────────
echo -e "\n${CYAN}[1/3] Cloning repository...${NC}"

if [ -d "$CLONE_DIR" ]; then
  echo -e "  Directory already exists. Pulling latest changes..."
  cd "$CLONE_DIR"
  git pull
else
  mkdir -p "$(dirname "$CLONE_DIR")"
  git clone "$REPO_URL" "$CLONE_DIR"
  echo -e "  ${GREEN}✔ Cloned into $CLONE_DIR${NC}"
fi

# ─────────────────────────────────────────────
# Step 2: Create k8s directory
# ─────────────────────────────────────────────
echo -e "\n${CYAN}[2/3] Creating k8s directory...${NC}"
mkdir -p "$K8S_DIR"
echo -e "  ${GREEN}✔ $K8S_DIR ready${NC}"

# ─────────────────────────────────────────────
# Step 3: Inject k8s manifests
# ─────────────────────────────────────────────
echo -e "\n${CYAN}[3/3] Injecting Kubernetes manifests...${NC}"

# namespace.yaml
cat > "$K8S_DIR/namespace.yaml" <<'EOF'
kind: Namespace
apiVersion: v1
metadata:
  name: notes-app
EOF
echo -e "  ${GREEN}✔ namespace.yaml${NC}"

# deployment.yaml
cat > "$K8S_DIR/deployment.yaml" <<'EOF'
kind: Deployment
apiVersion: apps/v1
metadata:
  name: notes-app-deployment
  namespace: notes-app
  labels:
    app: notes-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: notes-app
  template:
    metadata:
      labels:
        app: notes-app
    spec:
      containers:
        - name: notes-app
          image: devang0003/notes-app-k8s:latest
          ports:
            - containerPort: 8000
EOF
echo -e "  ${GREEN}✔ deployment.yaml${NC}"

# service.yaml
cat > "$K8S_DIR/service.yaml" <<'EOF'
kind: Service
apiVersion: v1
metadata:
  name: notes-app-service
  namespace: notes-app
spec:
  type: ClusterIP
  selector:
    app: notes-app
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 8000
EOF
echo -e "  ${GREEN}✔ service.yaml${NC}"

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   Setup complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nFiles created:"
ls -1 "$K8S_DIR"
echo -e "\nTo apply to your cluster, run:"
echo -e "  ${CYAN}kubectl apply -f $K8S_DIR/namespace.yaml${NC}"
echo -e "  ${CYAN}kubectl apply -f $K8S_DIR/deployment.yaml${NC}"
echo -e "  ${CYAN}kubectl apply -f $K8S_DIR/service.yaml${NC}"
echo -e "\nOr apply all at once:"
echo -e "  ${CYAN}kubectl apply -f $K8S_DIR/${NC}"
