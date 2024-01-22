# Étape de build
FROM node:16 AS build

# Créer le répertoire de l'application
WORKDIR /usr/src/app

# Installer les dépendances de l'application
# Le caractère joker est utilisé pour s'assurer que package.json ET package-lock.json sont copiés
# où disponible (npm@5+)
COPY package*.json ./

# Si vous utilisez yarn.lock décommentez la ligne suivante et supprimez la précédente
# COPY package.json yarn.lock ./

RUN npm install
# Ou si vous utilisez yarn, utilisez la commande suivante
# RUN yarn install --frozen-lockfile

# Bundle app source
COPY . .

# Construire l'application pour la production
RUN npm run build

# Étape de production
FROM nginx:stable-alpine as production

# Copier les fichiers de build depuis l'étape de construction à l'intérieur du conteneur
COPY --from=build /vite-project/dist /usr/share/nginx/html

# Exposer le port 80 pour l'application
EXPOSE 80

# Lancer nginx
CMD ["nginx", "-g", "daemon off;"]
