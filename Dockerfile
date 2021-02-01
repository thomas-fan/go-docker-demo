# 打包依赖阶段使用golang作为基础镜像
FROM golang:1.15 as builder
# 启用go module 并设置代理
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct
# 添加非 root 用户
RUN adduser -u 10001 app-runner
WORKDIR /build
# 安装项目依赖
ADD go.mod .
ADD go.sum .
RUN go mod download
# 拷贝项目文件
COPY . .

# 指定OS等，并go build
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build -a -o your-application .

# 运行阶段指定scratch作为基础镜像
FROM alpine as final
WORKDIR /app
COPY --from=builder /build/your-application .
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
USER app-runner
EXPOSE 8888

ENTRYPOINT ["./your-application"]
#  docker rm go-docker && docker rmi go-docker && docker build -t go-docker . && docker run -d -p 8888:8888 --name=go-docker go-docker