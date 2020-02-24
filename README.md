# nginx容器

> 对官方的nginx镜像修改了默认的配置文件

### 后续要增加的server站点
- http项目的.conf文件 映射到容器内的 /etc/nginx/conf.d 下
- 流转发项目的.conf文件 映射到容器内的 /etc/nginx/stream.d 下


##### 示例的docker-compose.yml
```yaml
nginx:
  image: test:nginx
  container_name: nginx
  volumes:
    - ./conf.d:/etc/nginx/conf.d            #里面放 http_server 的 conf 文件
    - ./stream.d:/etc/nginx/stream.d        #里面放 stream_proxy_server 的 conf 文件
  ports:
    - 80:80
    - 8080:8080 
    - 7011:7011
````

