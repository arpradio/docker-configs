<div align="center" text="center"S>
<img width="666" alt="psyencelab" src="https://github.com/user-attachments/assets/5bb0aa55-1ed2-4a00-a12e-793b4d2a7cc4" />

  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  [![Docker](https://img.shields.io/badge/Docker-20.10.8-blue.svg)](https://www.docker.com/)
</div>


:# Docker Compose YAML Configs for ARP Radio:


## Overview

This repository hosts a collection of Docker Compose YAML configurations designed for setting up various components and services for ARP Radio. These configurations simplify the deployment and management of services, ensuring a consistent and reproducible environment.

### Key Features

- Ready-to-use Docker Compose YAML files
- Configurations for different ARP Radio services and applications
- Easy setup and deployment
- Scalable and maintainable architecture

## Available Configurations

The repository contains the following YAML configurations:

1. **Database Setup**: PostgreSQL and Redis services
2. **Web Server**: Nginx and Node.js
3. **Monitoring**: Prometheus and Grafana
4. **Messaging**: RabbitMQ
5. **Media Services**: Icecast and Liquidsoap

## Prerequisites

- [Git](https://git-scm.com/) (2.30.0 or higher)
- [Docker](https://www.docker.com/) (20.10.8 or higher)
- [Docker Compose](https://docs.docker.com/compose/) (1.29.2 or higher)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/arpradio/docker-compose-configs.git
   cd docker-compose-configs
   ```

2. Navigate to the desired configuration directory:
   ```bash
   cd <configuration-directory>
   ```

3. Customize the `.env` file with your configuration:
   ```bash
   cp .env.example .env
   ```

4. Start the services:
   ```bash
   docker-compose up -d
   ```

## Usage

### Common Commands

- **Start Services**:
  ```bash
  docker-compose up -d
  ```

- **Stop Services**:
  ```bash
  docker-compose down
  ```

- **View Logs**:
  ```bash
  docker-compose logs -f
  ```

## Troubleshooting

### Common Issues

1. **Service Fails to Start**
   - Verify Docker and Docker Compose versions
   - Check `.env` configuration
   - Review logs for specific errors

2. **Network Issues**
   - Ensure Docker network settings are correct
   - Check firewall settings

3. **Resource Limits**
   - Verify system resources (CPU, RAM, Disk Space)
   - Adjust Docker resource allocations if needed

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [The Psyence Lab](https://psyencelab.media/) for their contributions and support
- All contributors to this project

## Contact

- Discord: [Join **_THE BLOCKCHAIN MUSIC COLLECTIVE_**](https://discord.gg/cBaWfKevkh)
- Twitter: [@psyencelab](https://x.com/ArpRadioweb3)
- Website: [psyencelab.media](https://psyencelab.media)
