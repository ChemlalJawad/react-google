# Étape de build
FROM node:16 AS build

# Créer le répertoire de l'application dans le conteneur
WORKDIR /app

# Copier les fichiers de configuration de l'application
COPY vite-project/package*.json ./

# Installer les dépendances de l'application
RUN npm install

# Copier les fichiers de l'application
COPY vite-project/ ./

# Construire l'application pour la production
RUN npm run build

# Étape de production
FROM nginx:stable-alpine as production

# Copier les fichiers de build depuis l'étape de construction à l'intérieur du conteneur
COPY --from=build /app/dist /usr/share/nginx/html

# Exposer le port 80 pour l'application
EXPOSE 80

# Lancer nginx
CMD ["nginx", "-g", "daemon off;"]
