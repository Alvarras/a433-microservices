# base image node versi alpine 
FROM node:18-alpine
# working directory container
WORKDIR /app
# Menyalin package.json dan package-lock.json
COPY package*.json ./
# Menginstall dependensi aplikasi
RUN npm install
# Menyalin seluruh source code ke dalam container
COPY . .
# Mengekspos port sesuai variabel environment
EXPOSE 3001
# Menjalankan aplikasi
CMD ["npm", "run", "start"]