#!/bin/bash

echo "Rebuilding the HOST container..."
docker-compose down
docker-compose up --build
