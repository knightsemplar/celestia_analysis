# Stop Celestia Service
sudo systemctl stop celestia-light

# Remove the Previous Service File
sudo rm /etc/systemd/system/celestia-light.service

# Create a System Service for Celestia
sudo tee /etc/systemd/system/celestia-light.service << EOF
[Unit]
Description=celestia-light Cosmos daemon
After=network-online.target
[Service]
User=ubuntu
ExecStart=/usr/local/bin/celestia light start --keyring.accname my_celes_key --p2p.network blockspacerace --core.ip https://rpc-blockspacerace.pops.one --gateway --gateway.addr localhost --metrics --metrics.tls=false --metrics.endpoint 0.0.0.0:4318
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

# Start Celestia Service
sudo systemctl daemon-reload
sudo systemctl restart celestia-light

# Check the Status of Celestia Service
sudo systemctl status celestia-light
