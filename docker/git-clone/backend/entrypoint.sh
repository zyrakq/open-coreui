#!/bin/bash
set -e

# Get database URL from environment variable or use default
DATABASE_URL="${DATABASE_URL:-sqlite:///app/data/database.sqlite3}"

# Extract the file path from the DATABASE_URL
# For sqlite:///app/data/database.sqlite3, we need /app/data/database.sqlite3
if [[ $DATABASE_URL == sqlite://* ]]; then
    # Remove sqlite:// prefix
    DB_PATH="${DATABASE_URL#sqlite://}"
    
    # Get the directory path
    DB_DIR=$(dirname "$DB_PATH")
    
    # Create directory if it doesn't exist
    if [ ! -d "$DB_DIR" ]; then
        echo "Creating database directory: $DB_DIR"
        mkdir -p "$DB_DIR"
    fi
    
    # Create empty database file if it doesn't exist
    if [ ! -f "$DB_PATH" ]; then
        echo "Creating database file: $DB_PATH"
        touch "$DB_PATH"
    fi
    
    echo "Database initialized at: $DB_PATH"
fi

# Execute the main application
exec "$@"