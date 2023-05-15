# celestia_analysis

This is a tool for setting up and performing analysis on a Celestia Light Node. It's targetted at the less saavy operator with the goal of providing a simple and easy to follow solution to running and analysing a node. 

**Software used:**

-Celestia Node 

-Docker

-Node_Exporter

-Otel Collector

-Prometheus

-Grafana


# Necessary Commands to Setup

# Setup Docker in Ubuntu
Set up the repository
1. Update the apt package index and install packages to allow apt to use a repository over HTTPS, add Docker’s official GPG key and set up the repository:

```
sudo apt-get update && sudo apt-get install ca-certificates curl gnupg -y && sudo install -m 0755 -d /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && sudo chmod a+r /etc/apt/keyrings/docker.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

# Install Docker Engine in Ubuntu

The below command installs Docker Engine, containerd, Docker Buildx plugin, and Docker Compose.

Downloads and installs Docker Compose binary.

Adds the ubuntu user to the docker group to allow Docker commands without sudo.

You will need to log out (`exit`) and log back in for the group membership to take effect.

```
sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y && sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose && sudo usermod -aG docker ubuntu
```

Now login again to the VM

# Setup Celestia Light Node in Ubuntu

Clone the repo:

```
git clone https://github.com/knightsemplar/celestia_analysis
```

Go inside the celestialight directory, make the script executable and run:

```
cd celestia_analysis/celestialight && chmod +x celestia-light-auto.sh && ./celestia-light-auto.sh
```

This will automatically set up and run a Celestia Light Node with a new wallet and default settings on the Blockspacerace network, it will also add metrics to allow analysis through Open Telemetry. Be sure to save your passphrase for future reference (search my_celes_key). 

Be aware: this can take a while. 

For a more customised set up, please refer to [this article]([url](https://solardefi.substack.com/)), Celestia docs, or a the repo in the resources section. 


# Setup OpenTelemetry Collector in Ubuntu

Go inside the celestia_analysis/openTelemetry directory, make the script executable and run the script:

`cd && cd celestia_analysis/openTelemetry && chmod +x setup-script.sh && ./setup-script.sh`

When the setup is completed successfully, you will see the output that the service is active and running.

# Setup Prometheus, Grafana, and Node Exporter

Now you have to run all of the necessary containers in docker. Run this command and check the running containers:

```
docker-compose up -d && docker ps
```

Now you will see all of the containers are running.

# Visualization From Grafana

To see the dashboard you need to open your browser and paste this url:

- If you run in cloud ubuntu server
http://your-server-public-ip:3000

- If you run in local
http://localhost:3000

- Credentials of Grafana

Username: admin

Password: admin

You can change it from project directory .env file

There will be three dashboards available to choose from, the first showing combined basic analysis. The second two offer more technical system analysis. 


# Screenshot of Celestia Dashboard

![image](https://github.com/knightsemplar/celestia_analysis/assets/81700275/c824bd46-f92f-4010-b015-726f2e32d6bb)

## References
1. https://docs.docker.com/engine/install/ubuntu/
2. https://github.com/GLCNI/celestia-node-scripts/tree/main/multi-network#readme
3. https://github.com/GLCNI/celestia-node-scripts/blob/main/multi-network/monitoring/prom
etheus/README.md
4. https://solardefi.substack.com/

