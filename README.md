# WordPress Docker Development Environment

This Docker Compose setup provides a complete WordPress development environment with PHP 8.4, MySQL, and phpMyAdmin.

## Services

- **WordPress**: Custom PHP 8.4-FPM container with WordPress latest
- **MySQL**: Database server (MySQL 8.0)
- **Nginx**: Web server for serving WordPress
- **phpMyAdmin**: Web-based MySQL administration tool

## Quick Start

1. **Start the environment:**
   ```bash
   docker compose up -d
   ```

2. **Access the services:**
   - WordPress: http://localhost:8080
   - phpMyAdmin: http://localhost:8081
   - MySQL: localhost:3306

3. **Stop the environment:**
   ```bash
   docker compose down
   ```

## Configuration

### Environment Variables
Edit the `.env` file to customize:
- Database credentials
- WordPress debug settings
- Passwords

### Default Credentials
- **MySQL Root Password**: `rootpassword123`
- **WordPress Database**: `wordpress`
- **WordPress DB User**: `wordpress`
- **WordPress DB Password**: `wordpress123`

## Volumes

- `./wp`: WordPress files and uploads (bind mount to host)
- `mysql_data`: MySQL database files

## Development Features

- PHP 8.4 with common extensions (GD, MySQL, ZIP, etc.)
- WordPress debug mode enabled
- Nginx with optimized configuration
- Persistent data storage
- Easy database administration via phpMyAdmin
- **WordPress files accessible on host** - Edit files directly in `./wp/` directory

## File Structure

```
wordpress-docker/
├── Dockerfile          # Custom WordPress PHP 8.4 image
├── docker-compose.yml  # Docker Compose configuration
├── nginx.conf          # Nginx configuration
├── .env               # Environment variables
├── wp/                # WordPress files (bind mount)
│   ├── wp-admin/      # WordPress admin files
│   ├── wp-content/    # Themes, plugins, uploads
│   ├── wp-includes/   # WordPress core files
│   └── ...            # Other WordPress files
└── README.md          # This file
```

## Troubleshooting

1. **Port conflicts**: If ports 80, 3306, or 8081 are in use, modify the ports in `docker-compose.yml`
2. **Permission issues**: Ensure Docker has proper permissions
3. **Database connection**: Wait for MySQL to fully start before accessing WordPress

## Useful Commands

```bash
# View logs
docker compose logs -f

# Rebuild containers
docker compose up --build -d

# Access WordPress container
docker compose exec wordpress bash

# Access MySQL container
docker compose exec mysql mysql -u root -p
```