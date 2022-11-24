# nginx容器

> 对官方的nginx镜像修改了默认的配置文件

### 后续要增加的server站点
- http项目的.conf文件 映射到容器内的 /etc/nginx/conf.d 下
- 流转发项目的.conf文件 映射到容器内的 /etc/nginx/stream.d 下



#### 环境变量

- WORK_PROCESSES

  默认为 4， nginx的工作进程数 ， 防止部分物理机核心多导致容器内存溢出

- WORK_USER

  默认 nginx，如果该项不是 nginx ，就会创建该值是用户

- WORK_USERID   （可选）

  如果${WORK_USER} 不是nginx ， 创建用户时候，用户的UID




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

如果要调试，需要安装一些工具，可以更新apk安装源
```bash
# 外网替换安装源
ali-internet-repositories

# 内网替换安装源
ali-internal-repositories

# 执行完之后 
apk update
```
