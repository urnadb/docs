---
title: TLS 连接
type: docs
prev: guide/data
next: guide/question
weight: 6
---

尽管采用可靠且安全的数据管理方式，并将数据文件保存在主机磁盘中，同时通过限制主机访问权限和静态数据加密来减少潜在的数据泄露风险，这些措施仍然不足以全面保障数据安全。由于 UrnaDB 部署在远程服务器上，业务应用层在访问数据时必须经过网络传输，因此在传输过程中仍存在被截获或篡改的风险。

UrnaDB 数据库的对外服务层基于 HTTP 协议，因此客户端与服务器之间的数据通信是通过 HTTP 进行的。然而 HTTP 协议在传输过程中采用明文传输方式，意味着数据包在网络上传输时可能会被截获或篡改，从而存在数据泄露的风险，可能导致数据库中的敏感信息被泄露。

> [!IMPORTANT]
> 在设计 UrnaDB 数据库架构时，我已经充分考虑到这一问题，选择基于 HTTP 协议进行数据交换的原因主要有以下几点：首先 HTTP 协议是当前最广泛使用的网络应用层协议，天生支持分布式网络请求处理。任何支持 HTTP 协议的应用程序都可以作为客户端参与通信，目前 HTTP 协议已经发展到 HTTP/2.0 版本，带来了许多性能优化，如多路复用、头部压缩等，进一步提升了效率，此外基于 TLS 协议的 HTTPS 连接可以保障数据传输的安全性，确保网络通信的隐私和完整性。




```conf
# HTTP 配置（监听 80 端口）
server {
    listen 80;
    server_name your-domain.com;  # 替换为你的域名

    # 强制将所有 HTTP 请求重定向到 HTTPS
    return 301 https://$host$request_uri;
}

# HTTPS 配置（监听 443 端口）
server {
    listen 443 ssl;
    server_name your-domain.com;  # 替换为你的域名

    ssl_certificate /etc/nginx/ssl/ssl.crt;       # SSL 证书路径
    ssl_certificate_key /etc/nginx/ssl/ssl.key;   # SSL 密钥路径

    ssl_protocols TLSv1.2 TLSv1.3;  # 推荐使用 TLS 1.2 和 1.3
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';  # 优化的密码套件
    ssl_prefer_server_ciphers on;  # 优先使用服务器配置的密码套件

    # 启用 HSTS（HTTP 严格传输安全）
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location / {
        proxy_pass http://localhost:2668;  # 将请求代理到 HTTP 服务（例如，本地 8080 端口）
        proxy_set_header Host $host;       # 保留原始 Host 头
        proxy_set_header X-Real-IP $remote_addr;  # 设置客户端真实 IP
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  # 设置代理链路的客户端 IP
        proxy_set_header X-Forwarded-Proto $scheme;  # 保留协议（http 或 https）
        proxy_set_header X-Forwarded-Port 443;  # 设置代理的端口
        proxy_redirect off;  # 关闭重定向
    }
}
```