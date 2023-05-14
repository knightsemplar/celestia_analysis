# Go to Temp Folder
cd /tmp

# Download Opentelemetry-Collector
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.75.0/otelcol_0.75.0_linux_amd64.tar.gz

# Extract Opentelemetry-Collector
tar xvf otelcol_0.75.0_linux_amd64.tar.gz

# Move the otelcol binaries to /usr/local/bin
sudo cp ./otelcol /usr/local/bin/

# Grant permissions (assumes user is ubuntu)
sudo chown ubuntu:ubuntu /usr/local/bin/otelcol

# Create yml file for otelcol
sudo mkdir /etc/otelcol/
sudo tee /etc/otelcol/otelcol.yml << EOF
receivers:
  otlp:
    protocols:
      grpc:
      http:
  prometheus:
    config:
      scrape_configs:
      - job_name: 'otel-collector'
        scrape_interval: 10s
        static_configs:
        - targets: ['0.0.0.0:8888']
exporters:
  otlphttp:
    endpoint: http://otel.celestia.tools:4318
  prometheus:
    endpoint: "0.0.0.0:8889"
    namespace: celestia
    send_timestamps: true
    metric_expiration: 180m
    enable_open_metrics: true
    resource_to_telemetry_conversion:
      enabled: true
processors:
  batch:
  memory_limiter:
    # 80% of maximum memory up to 2G
    limit_mib: 1500
    # 25% of limit up to 2G
    spike_limit_mib: 512
    check_interval: 5s
service:
  pipelines:
    metrics:
      receivers: [otlp, prometheus]
      exporters: [otlphttp, prometheus]
EOF

# Create a system service for otelcol
sudo tee /etc/systemd/system/otelcol.service << EOF
[Unit]
Description=OpenTelemetry Collector
Wants=network-online.target
After=network-online.target

[Service]
User=root
Type=simple
ExecStart=/usr/local/bin/otelcol --config /etc/otelcol/otelcol.yml

[Install]
WantedBy=multi-user.target
EOF

# Check Version
otelcol --version

# Enable, Start, & Check status of OpenTelemetry Collector
sudo systemctl enable otelcol.service
sudo systemctl start otelcol.service
sudo systemctl status otelcol.service

