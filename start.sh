#!/bin/sh
set -e

# Start Alloy in the background
alloy run /etc/alloy/config.alloy &

# Start the .NET API in foreground
dotnet /app/Examples.AspNetCore.dll