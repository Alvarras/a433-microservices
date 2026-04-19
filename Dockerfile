# Menggunakan base image Node.js versi 14 dengan Alpine Linux
FROM node:14-alpine

# Menentukan working directory untuk container adalah /app
WORKDIR /app

# Menyalin seluruh source code ke working directory di container
COPY . .

# Menentukan agar aplikasi berjalan dalam production mode dan menggunakan container bernama item-db sebagai database host
ENV NODE_ENV=production DB_HOST=item-db

# Menginstal dependencies untuk production dan kemudian build aplikasi
RUN npm install --production --unsafe-perm && npm run build

# Mengekspos port 8080 yang digunakan oleh aplikasi
EXPOSE 8080

# Saat container diluncurkan, jalankan server dengan perintah npm start
CMD ["npm", "start"]