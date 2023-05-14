# celestia_analysis

This is a tool for setting up and performing analysis on a Celestia Light Node. It's targetted at the less saavy operator with the goal of providing a simple and easy to follow solution to running and analysing a node. 

**Software used:**

-Celestia Node 

-Docker

-Node_Exporter

-Otel Collector

-Prometheus

-Grafana

Stack:

![image](https://github.com/knightsemplar/celestia_analysis/assets/81700275/9ab763d3-a659-4c92-92c9-97a362795c79)

# Necessary Commands to Setup

# Setup Docker in Ubuntu
Set up the repository
1. Update the apt package index and install packages to allow apt to use a
repository over HTTPS

`sudo apt-get update`

`sudo apt-get install ca-certificates curl gnupg`

2. Add Docker’s official GPG key:

`sudo install -m 0755 -d /etc/apt/keyrings`


`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`


`sudo chmod a+r /etc/apt/keyrings/docker.gpg`

3. Use the following command to set up the repository:

`echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`

# Install Docker Engine in Ubuntu

1. Update the apt package index:
`sudo apt-get update`

2. Install Docker Engine, containerd, and Docker Compose

`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`

3. Install docker-compose

`sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose; sudo chmod +x /usr/local/bin/docker-compose`

4. Add ubuntu user in docker group

`sudo usermod -aG docker ubuntu`

`exit`

Now login again to the VM

# Setup Celestia Light Node in Ubuntu

Clone the repo:

`git clone https://github.com/knightsemplar/celestia_analysis`


In the project directory go inside into the celestialight directory. Here you will find a
sciprt named setup-script.sh. Run that script.

1. Go inside the celestiaLight direcotry

`cd celestia_analysis/celestialight`

chmod +x celestia-light-auto.sh
celestia-light-auto.sh

2. Run script-1

`chmod +x setup-script-1.sh`

`./setup-script-1.sh`

3. You will be asked for some prompts in the terminal.

- Press 2 for selecting blockspacerace
- Press 1 for default
- Press 1 for auto generated wallet
- Enter
- Press y for showing the logs.

4. Run script-2

Make executable

`chmod +x setup-script-2.sh`

Run

`./setup-script-2.sh`

5. When the setup is completed successfully, you will see an output that the service is active and running.

# Setup OpenTelemetry Collector in Ubuntu

In the project directory go to the openTelemetry directory. Here you will find a
script named setup-script.sh. Run that script.

1. Go inside the celestia_analysis/openTelemetry directory

`cd celestia_analysis/openTelemetry`

2. Run script

Make executable

`chmod +x setup-script.sh`

`./setup-script.sh`

3. When the setup will be completed successfully, you will show the output the
service is active and running.

# Setup Prometheus, Grafana, and Node Exporter

1. Go to the project directory celestia_analysis/prometheus

`cd celestia_analysis/prometheus`

2. If run ubuntu from any cloud provider then you have public IP. If you run in local
then you have localhost or 127.0.0.1 IP. Provide that IP in prometheus.yml file instead of
the placeholder (Insert-Your-IP).

`nano prometheus.yml`


3. Now you have to run all of the necessary containers in docker. Run this command.

`docker-compose up -d`

4. Check the running containers

`docker ps`

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


# Screen Capture of Celestia Dashboard

![image](https://github.com/knightsemplar/celestia_analysis/assets/81700275/c824bd46-f92f-4010-b015-726f2e32d6bb)

## References
1. https://docs.docker.com/engine/install/ubuntu/
2. https://github.com/GLCNI/celestia-node-scripts/tree/main/multi-network#readme
3. https://github.com/GLCNI/celestia-node-scripts/blob/main/multi-network/monitoring/prom
etheus/README.md
10

