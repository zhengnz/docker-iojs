**docker-compose模板**
```yaml
hs:
  image: norman/iojs
  ports:
   - "9001:9001" #supervisor端口
   - "127.0.0.1:3022:22" #ssh端口
   - "8100:8100" #web服务端口
  volumes:
   - /proc:/writable-proc #配置这个可以修改somaxconn, 详情见supervisor.sh
   - /docker/data/web:/web #项目存放路径
   - /docker/data/app/log:/home/log #日志路径
   - /etc/localtime:/etc/localtime #与服务器日期同步 
  environment:
   - ROOT_PASS=123456 #ssh登陆密码
   - APP_NAME=app_name #项目名称，在项目下创建supervisor目录，将要配置的ini文件放入该目录，参考以下配置
```

**开机启动ssh服务**
```
[program:ssh]
command=./run-ssh.sh
user=root
autostart=true
autorestart=true
directory=/
stdout_logfile=/home/log/ssh.log
redirect_stderr=true
stderr_logfile = /home/log/ssh-err.log
stopsignal=QUIT
```

**开机启动web服务**
```
[program:app]
command=pm2 start app.js -i 1 --name hs --max-memory-restart 300M --no-daemon
user=root
autostart=true
autorestart=true
directory=/web/app_name
stdout_logfile=/home/log/app.log
redirect_stderr=true
stderr_logfile = /home/log/app-err.log
stopsignal=QUIT
```