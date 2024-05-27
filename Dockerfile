# Because snyk said it was cool 
FROM node:lts-alpine as deps

ENV NODE_ENV production

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./

# Install dependencies.
# If you add a package-lock.json speed your build by switching to 'npm ci'.
# RUN npm ci --only=production
RUN npm install --include=dev

RUN ls

COPY vite.config.ts ./
COPY tsconfig.json ./
COPY app ./app
COPY public ./

RUN npm run build
RUN npm prune --omit=dev

FROM deps as build

WORKDIR /usr/src/app

# Copy local code to the container image.
COPY --from=deps /usr/src/app /usr/src/app/

# Run the web service on container startup.
CMD ["npm", "start"]