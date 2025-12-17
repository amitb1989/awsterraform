
# Fetch latest Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    # Update base system, install Java 17 (Amazon Corretto) with javac
    if command -v dnf >/dev/null 2>&1; then
      dnf -y update
      dnf -y install java-17-amazon-corretto-devel
    else
      yum -y update
      yum -y install java-17-amazon-corretto-devel
    fi

    # Create app directory
    APP_DIR="/opt/helloworld"
    mkdir -p "$APP_DIR"
    chown ec2-user:ec2-user "$APP_DIR"

    # Write simple Java HTTP server (Hello World)
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

    # Compile the Java app
    sudo -u ec2-user bash -c "cd "$APP_DIR" && javac HelloWorldHttpServer.java"

    # Create systemd service
    cat > /etc/systemd/system/helloworld.service <<'UNIT'
    [Unit]
    Description=Java Hello World HTTP Server
    After=network.target

    [Service]
    User=ec2-user
    WorkingDirectory=/opt/helloworld
    ExecStart=/usr/bin/java HelloWorldHttpServer
    Restart=always
    RestartSec=5
    Environment=JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto

    [Install]
    WantedBy=multi-user.target
    UNIT

    # Start and enable service
    systemctl daemon-reload
    systemctl enable --now helloworld

    # Firewall not needed (SG handles), just log status
    systemctl status helloworld --no-pager || true
  EOF
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name

  user_data = local.user_data

  tags = merge({
    Name = "hello-ec2"
   }, var.tags)
}