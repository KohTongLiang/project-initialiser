#!/bin/bash

# Get the project name from the command line argument
project_name=$1

if [ -z "$project_name" ]; then
	  echo "Please provide a project name as the first argument."
		  exit 1
fi

# Create project folder and initialize
mkdir "$project_name"
cd "$project_name"
npm init -y

# Install dependencies
npm install express express nodemon cors dotenv

# Create environment variables file
touch .env
cat > .env <<EOL
PORT=3000
EOL

# Create and configure nodemon.json
cat > nodemon.json <<EOL
{
  "watch": ["src"],
  "ext": "js",
  "exec": "node ./src/index.js",
  "ignore": ["src/**/*.spec.js"]
}
EOL

# Update package.json with scripts
npx json -I -f package.json -e 'this.scripts={"start": "nodemon", "build": "tsc", "serve": "node dist/index.js"}'

# create source directory
mkdir src/

# Create index.js with a sample code
cat > src/index.js <<EOL
const dotnev = require("dotenv");
const express = require("express");
const cors = require("cors");

dotenv.config(); // Load environment variables

const port = process.env.PORT || 3000;

const app = express();
app.use(cors());
app.use(express.json());

app.listen(port, () => {
   console.log(\`Server is running on port \${port}\`);
});
EOL


