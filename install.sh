#!/bin/bash


rm -Rf chat-backend-enterness/
rm -Rf chat-frontend-enterness/

# Função para clonar e instalar um projeto
install_project() {
    local project_name="$1"
    local git_repo="$2"

    echo "Cloning and installing $project_name project..."
    if git clone "$git_repo" "$project_name"; then
        cd "$project_name" || { echo "Failed to change directory to $project_name. Exiting..."; exit 1; }
        npm install || { echo "Failed to install dependencies for $project_name. Exiting..."; exit 1; }
        cd - || { echo "Failed to change back to previous directory. Exiting..."; exit 1; }
    else
        echo "Failed to clone $project_name. Exiting..."
        exit 1
    fi
}

# Diretório onde este script está localizado
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Instalação do backend
install_project "chat-backend-enterness" "https://github.com/maxhertel/chat-backend-enterness"

# Instalação do frontend
install_project "chat-frontend-enterness" "https://github.com/maxhertel/chat-frontend-enterness"

# Iniciar backend
echo "Starting backend..."
cd "chat-backend-enterness"
npm run start &
echo "Backend started."

# Exibir o diretório atual
echo "Current directory after starting backend:"
pwd

# Esperar um pouco para garantir que o backend tenha tempo para iniciar
sleep 5

# Iniciar frontend
echo "Starting frontend..."
cd "$SCRIPT_DIR/chat-frontend-enterness" || { echo "Failed to change directory to frontend directory. Exiting..."; exit 1; }
npm start || { echo "Failed to start frontend. Exiting..."; exit 1; }

echo "Frontend started successfully."

exit 0