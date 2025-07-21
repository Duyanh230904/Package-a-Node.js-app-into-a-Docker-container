# Dockerfile cho ứng dụng Node.js

# Giai đoạn 1: Build (sử dụng multi-stage build để tạo image nhỏ hơn)
# Sử dụng base image chính thức của Node.js
FROM node:18-alpine AS build

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Sao chép package.json và package-lock.json (nếu có)
# Điều này giúp tận dụng Docker cache: nếu các file này không thay đổi,
# Docker sẽ không chạy lại npm install.
COPY package*.json ./

# Cài đặt các dependencies
RUN npm install

# Sao chép toàn bộ mã nguồn ứng dụng vào thư mục làm việc
COPY . .

# Giai đoạn 2: Production (tạo image cuối cùng)
# Sử dụng base image nhỏ hơn cho môi trường production
FROM node:18-alpine

# Đặt thư mục làm việc
WORKDIR /app

# Sao chép các dependencies đã cài đặt và mã nguồn từ giai đoạn build
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app .

# Mở cổng mà ứng dụng Node.js lắng nghe
EXPOSE 3000

# Lệnh để chạy ứng dụng khi container khởi động
CMD ["npm", "start"]