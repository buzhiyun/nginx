# nginx容器


### 后续要增加的server站点
- http项目的.conf文件 映射到容器内的 /etc/nginx/conf.d 下
- 流转发项目的.conf文件 映射到容器内的 /etc/nginx/stream.d 下


##### 示例的docker-compose.yml
```yaml
nginx:
  image: test:nginx
  container_name: nginx
  volumes:
    - ./conf.d:/etc/nginx/conf.d
    - ./stream.d:/etc/nginx/stream.d
  ports:
    - 80:80
    - 8080:8080 
    - 7011:7011
````

