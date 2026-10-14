# installation and prerequisites for node exporter on centos server
# install node exporter on centos server

#Step 1: Install Node Exporter
sudo useradd --no-create-home --shell /sbin/nologin node_exporter

cd /tmp
NE=1.8.2
wget https://github.com/prometheus/node_exporter/releases/download/v${NE}/node_exporter-${NE}.linux-amd64.tar.gz
tar -xvf node_exporter-${NE}.linux-amd64.tar.gz
sudo cp node_exporter-${NE}.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo restorecon -v /usr/local/bin/node_exporter

# Step 2: Create a systemd service file for Node Exporter

sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<'EOF'
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Step 3: Start Node Exporter
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
# HELP. If not, run: sudo journalctl -u node_exporter -n 30


# Step 4: Check Node Exporter is running
# Check the status of the Node Exporter service to ensure it is running correctly.
sudo systemctl status node_exporter


# Step 5: Check Node Exporter is running
# Check the status of the Node Exporter service to ensure it is running correctly.
http://localhost:9100/metrics



# Step 6: Add Node Exporter to Prometheus
# Appends a scrape job to the end of prometheus.yml and restarts Prometheus.

sudo tee -a /etc/prometheus/prometheus.yml > /dev/null <<'EOF'

  - job_name: "node"
    static_configs:
      - targets: ["localhost:9100"]
EOF


# step 7: Restart Prometheus to apply the changes
sudo systemctl restart prometheus

# Step 8: Verify Node Exporter is being scraped by Prometheus
# Use the Prometheus API to check the health of the targets being scraped
http://localhost:9090/api/v1/targets
