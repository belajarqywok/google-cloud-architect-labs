module.exports = {
  apps: [
    {
      name: 'notes_service',
      script: './src/server.js', 
      instances: 5,
      exec_mode: 'cluster', 
      watch: false, 
      autorestart: true, 
      max_memory_restart: '1G', 
      env: {
        NODE_ENV: 'production',
      },
    },
  ],
}
