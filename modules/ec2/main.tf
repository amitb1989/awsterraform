
locals {
  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail
    yum -y update
    yum -y install java-17-amazon-corretto-devel

    APP_DIR="/opt/helloworld"
    mkdir -p "$APP_DIR"
    chown ec2-user:ec2-user "$APP_DIR"

    cat > "$APP_DIR/HelloWorldHttpServer.java" <<'JCODE'
    import com.sun.net.httpserver.HttpServer;
    import com.sun.net.httpserver.HttpHandler;
    import com.sun.net.httpserver.HttpExchange;
    import java.io.IOException;
    import java.io.OutputStream;
    import java.net.InetSocketAddress;

    public class HelloWorldHttpServer {
      public static void main(String[] args) throws Exception {
        int port = 8080;
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/", new RootHandler());
        server.setExecutor(null);
        server.start();
        System.out.println("Server started on port " + port);
      }

      static class RootHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
          String response = "Hello World";
          exchange.getResponseHeaders().add("Content-Type", "text/plain; charset=utf-8");
          exchange.sendResponseHeaders(200, response.getBytes().length);
          try (OutputStream os = exchange.getResponseBody()) {
            os.write(response.getBytes());
          }
        }
      }
    }
    JCODE

    sudo -u ec2-user bash -c "cd \"$APP_DIR\" && javac HelloWorldHttpServer.java"

    cat > /etc/systemd/system/helloworld.service <<'UNIT'
    [Unit]
    Description=Java Hello World HTTP Server
    After=network.target

    [Service]
    User=ec2-user
    WorkingDirectory=/opt/helloworld
    ExecStart=/usr/bin/java -cp . HelloWorldHttpServer
    Restart=always
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    UNIT

    systemctl daemon-reload
    systemctl enable --now helloworld
  EOF
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name
  user_data                   = local.user_data

  tags = merge({
    Name = "hello-ec2"
  }, var.tags)
}