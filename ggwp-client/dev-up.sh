#!/bin/bash

echo "Rebuilding the CLIENT container..."
docker-compose down
docker-compose up --build
